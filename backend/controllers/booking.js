const supabase = require('../config/supabase.js');

async function bookService(req, res) {
  try {
    const {
      description,
      service_id,
      homeowner_id,
      sp_id,
      date,
      time,
      location
    } = req.body;

    if (!description || !service_id || !homeowner_id || !sp_id || !date || !time || !location) {
      return res.status(400).json({ error: "Missing required fields" });
    }

    // Insert booking
    const { data, error: bookingError } = await supabase
      .from("bookings")
      .insert({
        description,
        service_id,
        homeowner_id,
        sp_id,
        date,
        time,
        location
      })
      .select();

    if (bookingError) {
      console.error("Booking error:", bookingError);
      return res.status(500).json({ error: "Error creating booking" });
    }

    const booking = data[0];

    // Upload photos
    if (req.files && req.files.length > 0) {
      for (const file of req.files) {
        const safeName = file.originalname.replace(/\s/g, "_");
        const filePath = `booking_${booking.booking_id}/${Date.now()}_${safeName}`;

        // Upload to Supabase Storage
        const { data: uploadedFile, error: uploadError } = await supabase.storage
          .from("booking-photos")
          .upload(filePath, file.buffer);

        if (uploadError) {
          console.error("Upload error:", uploadError);
          continue;
        }

        // Get public URL
        const { data: urlData } = supabase.storage
          .from("booking-photos")
          .getPublicUrl(filePath);

        const photoUrl = urlData.publicUrl;


        await supabase
          .from("booking_images")
          .insert({
            booking_id: booking.booking_id,
            image_url: photoUrl
          });
      }
    }

    return res.status(201).json({
      message: "Service booked successfully",
      booking
    });

  } catch (err) {
    console.error("Server error:", err);
    return res.status(500).json({ error: "Server error" });
  }
}

async function getBookingOfUser(req, res) {

  try {
    const user_id = req.params.user_id;

    if (!user_id) {
      return res.status(400).json({ error: "user_id is required" });
    }

    const { data: bookings, error } = await supabase
      .from("bookings")
      .select(`
    booking_id,
    date,
    time,
    status,
    service_provider:service_providers!bookings_sp_id_fkey (
      sp_id,
      service_type,
      username:users!service_providers_sp_id_fkey (
        full_name
      ),
      service_category:service_type (
        name
      )
    ),
    price:services!bookings_service_id_fkey (
      price_amount
    )
  `)
      .eq("homeowner_id", user_id);

    if (error) {
      console.error(error);
      return res.status(500).json({ error: "Error fetching bookings" });
    }

    return res.json({ bookings });

  } catch (err) {
    console.error(err);
    return res.status(500).json({ error: "Server error" });
  }
}

module.exports = { bookService, getBookingOfUser };