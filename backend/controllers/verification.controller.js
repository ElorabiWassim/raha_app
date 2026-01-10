const supabase = require('../config/supabase');

const ensureServiceProviderUser = async (userId) => {
  const { data: user, error } = await supabase
    .from('users')
    .select('user_id, role')
    .eq('user_id', userId)
    .maybeSingle();

  if (error) {
    return { ok: false, error: 'Database error', details: error.message };
  }

  if (!user) {
    return { ok: false, error: 'User not found' };
  }

  if (user.role !== 'service_provider') {
    return { ok: false, error: 'Only service providers can submit verification' };
  }

  return { ok: true, user };
};

const getProviderApplication = async (userId) => {
  const { data, error } = await supabase
    .from('provider_applications')
    .select('application_id, user_id, documents_urls, status')
    .eq('user_id', userId)
    .maybeSingle();

  if (error) {
    return { ok: false, error: 'Database error', details: error.message };
  }

  return { ok: true, application: data };
};

exports.uploadDocument = async (req, res) => {
  try {
    const { user_id: userId, document_type: documentType, file_path: filePath } = req.body;

    if (!userId || !documentType || !filePath) {
      return res.status(400).json({
        success: false,
        error: 'user_id, document_type, and file_path are required',
      });
    }

    const guard = await ensureServiceProviderUser(userId);
    if (!guard.ok) {
      return res.status(400).json({ success: false, error: guard.error, details: guard.details });
    }

    const appResult = await getProviderApplication(userId);
    if (!appResult.ok) {
      return res.status(500).json({ success: false, error: appResult.error, details: appResult.details });
    }

    const existingUrls = (appResult.application && appResult.application.documents_urls) || {};
    const mergedUrls = {
      ...(existingUrls || {}),
      [documentType]: filePath,
    };

    if (!appResult.application) {
      const { error: insertError } = await supabase.from('provider_applications').insert({
        user_id: userId,
        documents_urls: mergedUrls,
        status: 'pending',
      });

      if (insertError) {
        return res.status(500).json({ success: false, error: 'Failed to create application', details: insertError.message });
      }
    } else {
      const { error: updateError } = await supabase
        .from('provider_applications')
        .update({ documents_urls: mergedUrls })
        .eq('user_id', userId);

      if (updateError) {
        return res.status(500).json({ success: false, error: 'Failed to update application', details: updateError.message });
      }
    }

    return res.json({
      success: true,
      data: {
        document_url: filePath,
        document_type: documentType,
      },
    });
  } catch (e) {
    console.error('uploadDocument error:', e);
    return res.status(500).json({ success: false, error: 'Internal server error' });
  }
};

exports.submitVerification = async (req, res) => {
  try {
    const {
      user_id: userId,
      experience_years: experienceYears,
      description,
      documents,
    } = req.body;

    if (!userId) {
      return res.status(400).json({ success: false, error: 'user_id is required' });
    }

    const guard = await ensureServiceProviderUser(userId);
    if (!guard.ok) {
      return res.status(400).json({ success: false, error: guard.error, details: guard.details });
    }

    const documentsUrls = {};
    if (Array.isArray(documents)) {
      for (const doc of documents) {
        const type = doc?.document_type || doc?.documentType;
        const url = doc?.document_url || doc?.documentUrl;
        if (type && url) documentsUrls[type] = url;
      }
    }

    const appResult = await getProviderApplication(userId);
    if (!appResult.ok) {
      return res.status(500).json({ success: false, error: appResult.error, details: appResult.details });
    }

    const existingUrls = (appResult.application && appResult.application.documents_urls) || {};
    const mergedUrls = {
      ...(existingUrls || {}),
      ...(documentsUrls || {}),
    };

    // Mark provider as verified immediately (requested behavior).
    // We update (not upsert) to avoid failing on NOT NULL constraints for missing profile columns.
    const spUpdate = {
      verification_status: 'verified',
    };
    if (experienceYears !== undefined && experienceYears !== null) {
      const parsed = Number(experienceYears);
      spUpdate.experience_years = Number.isFinite(parsed) ? parsed : 0;
    }
    if (typeof description === 'string') spUpdate.description = description;

    const { error: spUpdateError } = await supabase
      .from('service_providers')
      .update(spUpdate)
      .eq('sp_id', userId);

    if (spUpdateError) {
      return res.status(500).json({
        success: false,
        error: 'Failed to update service provider',
        details: spUpdateError.message,
      });
    }

    if (!appResult.application) {
      const { error: insertError } = await supabase.from('provider_applications').insert({
        user_id: userId,
        documents_urls: mergedUrls,
        status: 'verified',
      });

      if (insertError) {
        return res.status(500).json({ success: false, error: 'Failed to create application', details: insertError.message });
      }
    } else {
      const { error: updateError } = await supabase
        .from('provider_applications')
        .update({
          documents_urls: mergedUrls,
          status: 'verified',
        })
        .eq('user_id', userId);

      if (updateError) {
        return res.status(500).json({ success: false, error: 'Failed to update application', details: updateError.message });
      }
    }

    return res.json({
      success: true,
      data: {
        user_id: userId,
        status: 'verified',
      },
    });
  } catch (e) {
    console.error('submitVerification error:', e);
    return res.status(500).json({ success: false, error: 'Internal server error' });
  }
};

exports.getVerificationStatus = async (req, res) => {
  try {
    const { userId } = req.params;
    if (!userId) return res.status(400).json({ success: false, error: 'userId is required' });

    const guard = await ensureServiceProviderUser(userId);
    if (!guard.ok) {
      return res.status(400).json({ success: false, error: guard.error, details: guard.details });
    }

    const { data: sp, error: spError } = await supabase
      .from('service_providers')
      .select('verification_status')
      .eq('sp_id', userId)
      .maybeSingle();

    if (spError) {
      return res.status(500).json({ success: false, error: 'Database error', details: spError.message });
    }

    const { data: app, error: appError } = await supabase
      .from('provider_applications')
      .select('status')
      .eq('user_id', userId)
      .maybeSingle();

    if (appError) {
      return res.status(500).json({ success: false, error: 'Database error', details: appError.message });
    }

    return res.json({
      success: true,
      data: {
        verification_status: sp?.verification_status ?? 'pending',
        application_status: app?.status ?? 'pending',
      },
    });
  } catch (e) {
    console.error('getVerificationStatus error:', e);
    return res.status(500).json({ success: false, error: 'Internal server error' });
  }
};
