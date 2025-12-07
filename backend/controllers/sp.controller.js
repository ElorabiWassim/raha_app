const supabase = require('../config/supabase.js');

/**
 * Get reviews for a specific service provider
 */
exports.getReviewsForSP = async (req, res) => {
    try {
        const { spId } = req.params;

        if (!spId) {
            return res.status(400).json({
                success: false,
                error: 'Service provider ID is required'
            });
        }

        // Get reviews with homeowner details
        const { data: reviews, error } = await supabase
            .from('reviews')
            .select('*')
            .eq('sp_id', spId)
            .eq('status', 'visible')
            .order('created_at', { ascending: false });

        if (error) {
            console.error('Error fetching reviews:', error);
            return res.status(500).json({
                success: false,
                error: 'Failed to fetch reviews'
            });
        }

        // Get homeowner names for all reviews
        const formattedReviews = await Promise.all(reviews.map(async (review) => {
            const { data: homeowner } = await supabase
                .from('users')
                .select('full_name')
                .eq('user_id', review.homeowner_id)
                .single();

            return {
                review_id: review.review_id,
                booking_id: review.booking_id,
                homeowner_id: review.homeowner_id,
                homeowner_name: homeowner?.full_name || 'Anonymous',
                sp_id: review.sp_id,
                rating: review.rating,
                review_text: review.review_text,
                created_at: review.created_at,
                status: review.status
            };
        }));

        res.status(200).json({
            success: true,
            data: formattedReviews,
            count: formattedReviews.length
        });

    } catch (error) {
        console.error('Get reviews error:', error);
        res.status(500).json({
            success: false,
            error: error.message
        });
    }
};

/**
 * Get average rating for a service provider
 */
exports.getAverageRating = async (req, res) => {
    try {
        const { spId } = req.params;

        if (!spId) {
            return res.status(400).json({
                success: false,
                error: 'Service provider ID is required'
            });
        }

        // Get all visible reviews for this SP
        const { data: reviews, error } = await supabase
            .from('reviews')
            .select('rating')
            .eq('sp_id', spId)
            .eq('status', 'visible');

        if (error) {
            console.error('Error calculating average rating:', error);
            return res.status(500).json({
                success: false,
                error: 'Failed to calculate average rating'
            });
        }

        if (!reviews || reviews.length === 0) {
            return res.status(200).json({
                success: true,
                data: {
                    average_rating: 0,
                    total_reviews: 0
                }
            });
        }

        // Calculate average
        const totalRating = reviews.reduce((sum, review) => sum + review.rating, 0);
        const averageRating = totalRating / reviews.length;

        res.status(200).json({
            success: true,
            data: {
                average_rating: parseFloat(averageRating.toFixed(2)),
                total_reviews: reviews.length
            }
        });

    } catch (error) {
        console.error('Get average rating error:', error);
        res.status(500).json({
            success: false,
            error: error.message
        });
    }
};
