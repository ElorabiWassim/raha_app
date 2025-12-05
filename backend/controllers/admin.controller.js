const supabase = require('../config/supabase.js');

// 1. Get all applications (with filters)
exports.getApplications = async (req, res) => {
    try {
        const { status = 'pending' } = req.query;

        const { data, error } = await supabase
            .from('provider_application')
            .select(`
        *,
        user:users(full_name, email, phone_number)
      `)
            .eq('status', status)
            .order('submitted_at', { ascending: false });

        if (error) throw error;
        res.json({ success: true, data });
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
};

// 2. Approve an application
exports.approveApplication = async (req, res) => {
    try {
        const { id } = req.params;

        // Update application status
        const { error: appError } = await supabase
            .from('provider_application')
            .update({ status: 'approved' })
            .eq('application_id', id);

        if (appError) throw appError;

        // Get user_id from application
        const { data: application } = await supabase
            .from('provider_application')
            .select('user_id')
            .eq('application_id', id)
            .single();

        // Update service_provider verification status
        const { error: spError } = await supabase
            .from('service_providers')
            .update({ verification_status: 'verified' })
            .eq('sp_id', application.user_id);

        if (spError) throw spError;

        res.json({ success: true, message: 'Application approved successfully' });
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
};

// 3. Get reports
exports.getReports = async (req, res) => {
    try {
        const { status, search } = req.query;

        let query = supabase
            .from('reports')
            .select(`
        *,
        homeowner:homeowners(user:users(full_name, email)),
        service_provider:service_providers(user:users(full_name, email))
      `)
            .order('created_at', { ascending: false });

        if (status) query = query.eq('status', status);
        if (search) query = query.ilike('description', `%${search}%`);

        const { data, error } = await query;
        if (error) throw error;
        res.json({ success: true, data });
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
};

// 4. Get dashboard statistics
exports.getDashboardStats = async (req, res) => {
    try {
        // Run all stats queries in parallel
        const [
            { count: totalUsers },
            { count: verifiedSPs },
            { count: activeBookings },
            { data: recentApplications },
            { data: recentReports }
        ] = await Promise.all([
            supabase.from('users').select('*', { count: 'exact', head: true }),
            supabase.from('service_providers').select('*', { count: 'exact', head: true }).eq('verification_status', 'verified'),
            supabase.from('bookings').select('*', { count: 'exact', head: true }).eq('status', 'accepted'),
            supabase.from('provider_application').select('*').eq('status', 'pending').limit(5),
            supabase.from('reports').select('*').eq('status', 'new').limit(5)
        ]);

        // Calculate revenue (example: from subscriptions)
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

// 5. Get all reviews
exports.getReviews = async (req, res) => {
    try {
        const { data, error } = await supabase
            .from('reviews')
            .select(`
        *,
        homeowner:homeowners(user:users(full_name)),
        service_provider:service_providers(user:users(full_name))
      `)
            .order('created_at', { ascending: false });

        if (error) throw error;
        res.json({ success: true, data });
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
};


exports.deleteReview = async (req, res) => {
    try {
        const { id } = req.params;

        const { error } = await supabase
            .from('reviews')
            .delete()
            .eq('review_id', id);

        if (error) throw error;
        res.json({ success: true, message: 'Review deleted successfully' });
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
};
