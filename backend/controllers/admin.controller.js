const supabase = require('../config/supabase.js');

exports.getApplications = async (req, res) => {
    try {
        const { status, search } = req.query;

        let query = supabase
            .from('provider_applications')
            .select(`
        *,
        user:users!provider_applications_user_id_fkey(
          full_name, 
          email, 
          phone_number,
          role,
          created_at
        )
      `)
            .order('submitted_at', { ascending: false });

        if (status) {
            query = query.eq('status', status);
        }

        if (search) {
            query = query.or(`review_notes.ilike.%${search}%`);
        }

        const { data, error } = await query;
        if (error) throw error;

        res.json({
            success: true,
            data
        });
    } catch (error) {
        console.error('Error in getApplications:', error);
        res.status(500).json({
            success: false,
            error: error.message
        });
    }
};

exports.getApplicationById = async (req, res) => {
    try {
        const { id } = req.params;

        const { data, error } = await supabase
            .from('provider_applications')
            .select(`
        *,
        user:users!provider_applications_user_id_fkey(
          full_name, 
          email, 
          phone_number,
          role,
          created_at
        )
      `)
            .eq('application_id', id)
            .single();

        if (error) throw error;
        res.json({ success: true, data });
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
};

exports.approveApplication = async (req, res) => {
    try {
        const { id } = req.params;

        // Get application with user info
        const { data: application, error: appFetchError } = await supabase
            .from('provider_applications')
            .select(`
        application_id,
        user_id,
        user:users!provider_applications_user_id_fkey(role)
      `)
            .eq('application_id', id)
            .single();

        if (appFetchError) throw appFetchError;

        // Update application status
        const { error: appUpdateError } = await supabase
            .from('provider_applications')
            .update({
                status: 'verified'
            })
            .eq('application_id', id);

        if (appUpdateError) throw appUpdateError;

        // Check if user is already a service provider
        const { data: existingSP } = await supabase
            .from('service_providers')
            .select('sp_id')
            .eq('sp_id', application.user_id)
            .single();

        if (existingSP) {
            // Update existing service provider
            const { error: spUpdateError } = await supabase
                .from('service_providers')
                .update({ verification_status: 'verified' })
                .eq('sp_id', application.user_id);

            if (spUpdateError) throw spUpdateError;
        } else if (application.user.role === 'service_provider') {
            // Create service_provider entry if user has service_provider role
            const { error: spCreateError } = await supabase
                .from('service_providers')
                .insert({
                    sp_id: application.user_id,
                    verification_status: 'verified',
                    created_at: new Date().toISOString()
                });

            if (spCreateError) throw spCreateError;
        }

        res.json({
            success: true,
            message: 'Application approved successfully'
        });
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
};

exports.rejectApplication = async (req, res) => {
    try {
        const { id } = req.params;

        const { error } = await supabase
            .from('provider_applications')
            .update({
                status: 'rejected'
            })
            .eq('application_id', id);

        if (error) throw error;
        res.json({ success: true, message: 'Application rejected successfully' });
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
};

exports.getReports = async (req, res) => {
    try {
        const { status, search } = req.query;

        console.log(`Getting reports with filter - status: ${status}, search: ${search}`);

        let query = supabase
            .from('reports')
            .select(`
        *,
        homeowner:homeowners!reports_homeowner_id_fkey(
          homeowner_id,
          user:users!homeowners_homeowner_id_fkey(
            full_name, 
            email
          )
        ),
        service_provider:service_providers!reports_sp_id_fkey(
          sp_id,
          user:users!service_providers_sp_id_fkey(
            full_name, 
            email
          )
        )
      `)
            .order('created_at', { ascending: false });

        if (status) query = query.eq('status', status);
        if (search) {
            query = query.or(`description.ilike.%${search}%`);
        }

        const { data, error } = await query;
        if (error) throw error;
        console.log(`Found ${data.length} reports with status: ${status || 'all'}`);
        res.json({ success: true, data });
    } catch (error) {
        console.error('Error in getReports:', error);
        res.status(500).json({ success: false, error: error.message });
    }
};

exports.getReportById = async (req, res) => {
    try {
        const { id } = req.params;

        const { data, error } = await supabase
            .from('reports')
            .select(`
        *,
        homeowner:homeowners!reports_homeowner_id_fkey(
          homeowner_id,
          user:users!homeowners_homeowner_id_fkey(full_name, email)
        ),
        service_provider:service_providers!reports_sp_id_fkey(
          sp_id,
          user:users!service_providers_sp_id_fkey(full_name, email)
        )
      `)
            .eq('report_id', id)
            .single();

        if (error) throw error;
        res.json({ success: true, data });
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
};

exports.updateReportStatus = async (req, res) => {
    try {
        const { id } = req.params;
        const { status } = req.body;

        console.log(`Updating report ${id} to status: ${status}`);

        if (!['new', 'in_progress', 'resolved'].includes(status)) {
            return res.status(400).json({
                success: false,
                error: 'Invalid status. Must be: new, in_progress, resolved, or dismissed'
            });
        }

        const { error } = await supabase
            .from('reports')
            .update({ status })
            .eq('report_id', id);

        if (error) throw error;
        console.log(`Report ${id} status updated successfully to ${status}`);
        res.json({ success: true, message: `Report status updated to ${status}` });
    } catch (error) {
        console.error('Error updating report status:', error);
        res.status(500).json({ success: false, error: error.message });
    }
};

exports.getDashboardStats = async (req, res) => {
    try {
        const [
            { count: totalUsers },
            { count: verifiedSPs },
            { count: activeBookings },
            { data: recentApplications },
            { data: recentReports }
        ] = await Promise.all([
            supabase.from('users').select('*', { count: 'exact', head: true }),
            supabase.from('service_providers')
                .select('*', { count: 'exact', head: true })
                .eq('verification_status', 'verified'),
            supabase.from('bookings')
                .select('*', { count: 'exact', head: true })
                .eq('status', 'accepted'),
            supabase.from('provider_applications')
                .select(`
                    *,
                    user:users!provider_applications_user_id_fkey(full_name, email)
                `)
                .eq('status', 'pending')
                .limit(5),
            supabase.from('reports')
                .select(`
                    *,
                    homeowner:homeowners!reports_homeowner_id_fkey(
                        user:users!homeowners_homeowner_id_fkey(full_name)
                    )
                `)
                .eq('status', 'new')
                .limit(5)
        ]);

        const { data: subscriptions } = await supabase
            .from('subscriptions')
            .select('price')
            .eq('status', 'active');

        const revenue = subscriptions?.reduce((sum, sub) => sum + (sub.price || 0), 0) || 0;

        res.json({
            success: true,
            data: {
                totalUsers,
                verifiedSPs,
                activeBookings,
                revenue,
                pendingApplications: recentApplications?.length || 0,
                newReports: recentReports?.length || 0,
                recentApplications,
                recentReports
            }
        });
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
};