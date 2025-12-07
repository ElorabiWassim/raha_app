const supabase = require('../config/supabase.js');

exports.addReview = async (req, res) => {
    try {

        req.user = {
            user_id: '5e7910fe-9b5e-4d0a-adeb-327e8781c0e7', // Mock UUID
            role: 'homeowner',
            email: 'test@example.com'
        };

        const { booking_id, sp_id, rating, review_text } = req.body;
        const homeowner_id = req.user.user_id;

        if (!booking_id || !sp_id || !rating) {
            return res.status(400).json({
                success: false,
                error: "booking_id, sp_id, and rating are required"
            });
        }

        if (req.user.role !== 'homeowner') {
            return res.status(403).json({
                success: false,
                error: "Only homeowners can submit reviews"
            });
        }

        // Check if booking exists and belongs to this homeowner and SP and is completed
        const { data: booking, error: bookingError } = await supabase
            .from('bookings')
            .select('booking_id, homeowner_id, sp_id, status, service_id')
            .eq('booking_id', booking_id)
            .eq('homeowner_id', homeowner_id)
            .eq('sp_id', sp_id)
            .eq('status', 'completed')
            .single();

        if (bookingError || !booking) {
            return res.status(404).json({
                success: false,
                error: "No completed booking found with these details"
            });
        }

        // Check if review already exists for this booking
        const { data: existingReview, error: reviewError } = await supabase
            .from('reviews')
            .select('review_id')
            .eq('booking_id', booking_id)

        if (existingReview && existingReview.length > 0) {
            return res.status(400).json({
                success: false,
                error: "You have already reviewed this booking"
            });
        }

        // Create review
        const { data: review, error } = await supabase
            .from('reviews')
            .insert({
                booking_id: booking_id,
                homeowner_id: homeowner_id,
                sp_id: sp_id,
                rating: rating,
                review_text: review_text?.trim() || null,
                status: 'visible'

            })
            .select(`
                review_id,
                booking_id,
                homeowner_id,
                sp_id,
                rating,
                review_text,
                created_at,
                updated_at,
                status
            `)
            .single();

        if (error) throw error;

        res.status(201).json({ success: true, message: "Review submitted successfully", data: review });




    } catch (error) {
        console.error('Add review error:', error);
        res.status(500).json({ success: false, error: error.message });
    }
};

