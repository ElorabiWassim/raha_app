const supabase = require('../config/supabase.js');

async function uploadProfilePicture(req, res) {
  try {
    const { sp_id } = req.body; 
    const file = req.file; 
    if (!sp_id) {
      return res.status(400).json({ error: "Missing service provider ID (sp_id)" });
    }

    if (!file) {
      return res.status(400).json({ error: "No file uploaded" });
    }

    const safeName = file.originalname.replace(/\s/g, "_");
    const filePath = `service_provider_${sp_id}/profile_${Date.now()}_${safeName}`;

    const { data: uploadData, error: uploadError } = await supabase.storage
      .from('service-providers-profile-photos')
      .upload(filePath, file.buffer, { upsert: true });

    if (uploadError) {
      console.error("Upload error:", uploadError);
      return res.status(500).json({ error: "Failed to upload image" });
    }

    // Get public URL
    const { data: urlData } = supabase.storage
      .from('service-provider-photos')
      .getPublicUrl(filePath);

    const publicUrl = urlData.publicUrl;

    // Update service_providers table
    const { error: dbError } = await supabase
      .from('service_providers')
      .update({ profile_picture_url: publicUrl })
      .eq('sp_id', sp_id);

    if (dbError) {
      console.error("DB update error:", dbError);
      return res.status(500).json({ error: "Failed to update profile picture in database" });
    }

    return res.status(200).json({
      message: "Profile picture uploaded successfully",
      profile_picture_url: publicUrl
    });

  } catch (err) {
    console.error("Server error:", err);
    return res.status(500).json({ error: "Server error" });
  }
}

module.exports = { uploadProfilePicture };
