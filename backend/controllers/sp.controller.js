const supabase = require('../config/supabase');
const addService = async (req, res) => {
  try {
    const { name, description, category_id, price_type, price_amount } = req.body;
    const sp_id = req.serviceProvider.sp_id;

    const { data: category, error: catError } = await supabase
      .from('service_categories')
      .select('category_id')
      .eq('category_id', category_id)
      .single();

    if (catError || !category) {
      return res.status(404).json({ error: 'Category not found' });
    }

    const { data: service, error } = await supabase
      .from('services')
      .insert({
        sp_id,
        name,
        description,
        category_id,
        price_type,
        price_amount,
        created_at: new Date().toISOString(),
        updated_at: new Date().toISOString()
      })
      .select()
      .single();

    if (error) {
      throw error;
    }

    res.status(201).json({
      message: 'Service added successfully',
      service
    });
  } catch (error) {
    console.error('Add service error:', error);
    res.status(500).json({ error: 'Failed to add service' });
  }
};

const editService = async (req, res) => {
  try {
    const { serviceId } = req.params;
    const sp_id = req.serviceProvider.sp_id;
    const updates = req.body;
    // Verify service belongs to this SP
    const { data: service, error: fetchError } = await supabase
      .from('services')
      .select('service_id')
      .eq('service_id', serviceId)
      .eq('sp_id', sp_id)
      .single();

    if (fetchError || !service) {
      return res.status(404).json({ error: 'Service not found' });
    }

    updates.updated_at = new Date().toISOString();

    const { data: updatedService, error } = await supabase
      .from('services')
      .update(updates)
      .eq('service_id', serviceId)
      .select()
      .single();

    if (error) {
      throw error;
    }

    res.json({
      message: 'Service updated successfully',
      service: updatedService
    });
  } catch (error) {
    console.error('Edit service error:', error);
    res.status(500).json({ error: 'Failed to update service' });
  }
};

const deleteService = async (req, res) => {
  try {
    const { serviceId } = req.params;
    const sp_id = req.serviceProvider.sp_id;


    const { data: service, error: fetchError } = await supabase
      .from('services')
      .select('service_id')
      .eq('service_id', serviceId)
      .eq('sp_id', sp_id)
      .single();

    if (fetchError || !service) {
      return res.status(404).json({ error: 'Service not found' });
    }

    const { error } = await supabase
      .from('services')
      .delete()
      .eq('service_id', serviceId);

    if (error) {
      throw error;
    }

    res.json({ message: 'Service deleted successfully' });
  } catch (error) {
    console.error('Delete service error:', error);
    res.status(500).json({ error: 'Failed to delete service' });
  }
};

const getMyServices = async (req, res) => {
  try {
    const sp_id = req.serviceProvider.sp_id;

    const { data: services, error } = await supabase
      .from('services')
      .select(`
        *,
        service_categories (
          category_id,
          name,
          description
        )
      `)
      .eq('sp_id', sp_id)
      .order('created_at', { ascending: false });

    if (error) {
      throw error;
    }

    res.json({ services });
  } catch (error) {
    console.error('Get services error:', error);
    res.status(500).json({ error: 'Failed to fetch services' });
  }
};
const getServiceById = async (req, res) => {
  try {
    const { serviceId } = req.params; // Extract service ID from URL params
    const sp_id = req.serviceProvider.sp_id; // From authenticated SP

    const { data: service, error } = await supabase
      .from('services')
      .select(`
        *,
        service_categories (
          category_id,
          name,
          description
        )
      `)
      .eq('service_id', serviceId)
      .eq('sp_id', sp_id) // Ensure the service belongs to this SP
      .single();

    if (error) {
      if (error.code === 'PGRST116') {
        // No rows returned (not found or not owned by this SP)
        return res.status(404).json({ error: 'Service not found or access denied' });
      }
      throw error;
    }

    res.json({ service });
  } catch (error) {
    console.error('Get service by ID error:', error);
    res.status(500).json({ error: 'Failed to fetch service' });
  }
};

const getDemands = async (req, res) => {
  try {
    const { category_id, status = 'open', page = 1, limit = 20 } = req.query;
    const offset = (page - 1) * limit;

    let query = supabase
      .from('demands')
      .select(`
        *,
        homeowners (
          homeowner_id,
          home_address,
           users (
        full_name  
            )
        ),
        service_categories (
          category_id,
          name
        )
      `, { count: 'exact' })
      .eq('status', status)
      .order('created_at', { ascending: false })
      .range(offset, offset + limit - 1);

    if (category_id) {
      query = query.eq('category_id', category_id);
    }

    const { data: demands, error, count } = await query;

    if (error) {
      throw error;
    }

    res.json({
      demands,
      pagination: {
        page: parseInt(page),
        limit: parseInt(limit),
        total: count,
        totalPages: Math.ceil(count / limit)
      }
    });
  } catch (error) {
    console.error('Get demands error:', error);
    res.status(500).json({ error: 'Failed to fetch demands' });
  }
};
const getDemandsByWilaya = async (req, res) => {
  try {
    const { wilaya } = req.params;
    const { page = 1, limit = 20 } = req.query;
    const offset = (page - 1) * limit;

    const { data: demands, error, count } = await supabase
      .from('demands')
      .select(`
        *,
        homeowners (
          homeowner_id,
          home_address,
          users (full_name)
        ),
        service_categories (
          category_id,
          name,
          description
        ),
        demand_images (
          image_id,
          image_url
        )
      `, { count: 'exact' })
      .eq('status', 'open')
      .ilike('location', `%${wilaya}%`)
      .order('created_at', { ascending: false })
      .range(offset, offset + limit - 1);

    if (error) {
      throw error;
    }


    res.json({
      success: true,
      wilaya: wilaya,
      demands: demands,
      pagination: {
        page: parseInt(page),
        limit: parseInt(limit),
        total: count,
        totalPages: Math.ceil(count / limit)
      }
    });
  } catch (error) {
    console.error('Get demands by wilaya error:', error);
    res.status(500).json({ 
      success: false,
      error: 'Failed to fetch demands by wilaya' 
    });
  }
};



const getDemandsByCategory = async (req, res) => {
  try {
    const { categoryId } = req.params;
    const { page = 1, limit = 20 } = req.query;
    const offset = (page - 1) * limit;

    const { data: category, error: catError } = await supabase
      .from('service_categories')
      .select('*')
      .eq('category_id', categoryId)
      .single();

    if (catError || !category) {
      return res.status(404).json({ 
        success: false,
        error: 'Category not found' 
      });
    }

    const { data: demands, error, count } = await supabase
      .from('demands')
      .select(`
        *,
        homeowners (
          homeowner_id,
          home_address,
          users (full_name)
        ),
        service_categories (
          category_id,
          name,
          description
        ),
        demand_images (
          image_id,
          image_url
        )
      `, { count: 'exact' })
      .eq('status', 'open')
      .eq('category_id', categoryId)
      .order('created_at', { ascending: false })
      .range(offset, offset + limit - 1);

    if (error) {
      throw error;
    }

   

    res.json({
      success: true,
      category: {
        category_id: category.category_id,
        name: category.name,
        description: category.description
      },
      demands: demands,
      pagination: {
        page: parseInt(page),
        limit: parseInt(limit),
        total: count,
        totalPages: Math.ceil(count / limit)
      }
    });
  } catch (error) {
    console.error('Get demands by category error:', error);
    res.status(500).json({ 
      success: false,
      error: 'Failed to fetch demands by category' 
    });
  }
};



const searchDemandsByTitle = async (req, res) => {
  try {
    const { query: searchQuery } = req.query;
    const { page = 1, limit = 20 } = req.query;
    const offset = (page - 1) * limit;

    if (!searchQuery || searchQuery.trim().length < 2) {
      return res.status(400).json({ 
        success: false,
        error: 'Search query must be at least 2 characters' 
      });
    }

    const { data: demands, error, count } = await supabase
      .from('demands')
      .select(`
        *,
        homeowners (
          homeowner_id,
          home_address ,
          users (full_name  )
        ),
        service_categories (
          category_id,
          name,
          description
        ),
        demand_images (
          image_id,
          image_url
        )
      `, { count: 'exact' })
      .eq('status', 'open')
      .ilike('title', `%${searchQuery}%`)
      .order('created_at', { ascending: false })
      .range(offset, offset + limit - 1);

    if (error) {
      throw error;
    }

    res.json({
      success: true,
      search_query: searchQuery,
      results_found: count,
      demands: demands,
      pagination: {
        page: parseInt(page),
        limit: parseInt(limit),
        total: count,
        totalPages: Math.ceil(count / limit)
      }
    });
  } catch (error) {
    console.error('Search demands error:', error);
    res.status(500).json({ 
      success: false,
      error: 'Failed to search demands' 
    });
  }
};
const createCategory = async (req, res) => {
  try {
    const { name, description } = req.body;

    if (!name) {
      return res.status(400).json({ error: 'Category name is required' });
    }

    // Check if category already exists
    const { data: existing, error: checkError } = await supabase
      .from('service_categories')
      .select('category_id')
      .eq('name', name);

    if (checkError) {
      throw checkError;
    }

    if (existing && existing.length > 0) {
      return res.status(400).json({ error: 'Category already exists' });
    }

    const { data: category, error } = await supabase
      .from('service_categories')
      .insert({
        name,
        description
      })
      .select()
      .single();

    if (error) {
      throw error;
    }

    res.status(201).json({
      message: 'Category created successfully',
      category
    });
  } catch (error) {
    console.error('Create category error:', error);
    res.status(500).json({ error: 'Failed to create category' });
  }
};

const getDemandDetails = async (req, res) => {
  try {
    const { demandId } = req.params;

    const { data: demand, error } = await supabase
      .from('demands')
      .select(`
        *,
        homeowners (
          homeowner_id,
          home_address,
          users(full_name)
        ),
        service_categories (
          category_id,
          name,
          description
        ),
        demand_images (
          image_id,
          image_url
        )
      `)
      .eq('demand_id', demandId)
      .single();

    if (error || !demand) {
      return res.status(404).json({ error: 'Demand not found' });
    }

    res.json({ demand });
  } catch (error) {
    console.error('Get demand details error:', error);
    res.status(500).json({ error: 'Failed to fetch demand details' });
  }
};

const sendOffer = async (req, res) => {
  try {
    const { demand_id, message, proposed_price, proposed_date } = req.body;
    const sp_id = req.serviceProvider.sp_id;

    // Verify demand exists and is open
    const { data: demand, error: demandError } = await supabase
      .from('demands')
      .select('status')
      .eq('demand_id', demand_id)
      .single();

    if (demandError || !demand) {
      return res.status(404).json({ error: 'Demand not found' });
    }

    if (demand.status !== 'open') {
      return res.status(400).json({ error: 'Demand is not open for offers' });
    }

    // Check if SP already sent an offer
    const { data: existingOffer } = await supabase
      .from('demand_offers')
      .select('offer_id')
      .eq('demand_id', demand_id)
      .eq('sp_id', sp_id)
      .single();

    if (existingOffer) {
      return res.status(400).json({ error: 'You already sent an offer for this demand' });
    }

    const { data: offer, error } = await supabase
      .from('demand_offers')
      .insert({
        demand_id,
        sp_id,
        message,
        proposed_price,
        proposed_date,
        status: 'pending',
        created_at: new Date().toISOString()
      })
      .select()
      .single();

    if (error) {
      throw error;
    }

    res.status(201).json({
      message: 'Offer sent successfully',
      offer
    });
  } catch (error) {
    console.error('Send offer error:', error);
    res.status(500).json({ error: 'Failed to send offer' });
  }
};

const getMyOffers = async (req, res) => {
  try {
    const sp_id = req.serviceProvider.sp_id;
    const { status, page = 1, limit = 20 } = req.query;
    const offset = (page - 1) * limit;

    let query = supabase
      .from('demand_offers')
      .select(`
        *,
        demands (
          demand_id,
          title,
          description,
          status,
          homeowners (
            homeowner_id,
            home_address
          )
        )
      `, { count: 'exact' })
      .eq('sp_id', sp_id)
      .order('created_at', { ascending: false })
      .range(offset, offset + limit - 1);

    if (status) {
      query = query.eq('status', status);
    }

    const { data: offers, error, count } = await query;

    if (error) {
      throw error;
    }

    res.json({
      offers,
      pagination: {
        page: parseInt(page),
        limit: parseInt(limit),
        total: count,
        totalPages: Math.ceil(count / limit)
      }
    });
  } catch (error) {
    console.error('Get offers error:', error);
    res.status(500).json({ error: 'Failed to fetch offers' });
  }
};

const getOfferDetails = async (req, res) => {
  try {
    const { offerId } = req.params;
    const sp_id = req.serviceProvider.sp_id;

    const { data: offer, error } = await supabase
      .from('demand_offers')
      .select(`
        *,
        demands (
          *,
          homeowners (
            homeowner_id,
            home_address
          ),
          demand_images (
            image_id,
            image_url
          )
        )
      `)
      .eq('offer_id', offerId)
      .eq('sp_id', sp_id)
      .single();

    if (error || !offer) {
      return res.status(404).json({ error: 'Offer not found' });
    }

    res.json({ offer });
  } catch (error) {
    console.error('Get offer details error:', error);
    res.status(500).json({ error: 'Failed to fetch offer details' });
  }
};

// Bookings
const getMyBookings = async (req, res) => {
  try {
    const sp_id = req.serviceProvider.sp_id;
    const { status, page = 1, limit = 20 } = req.query;
    const offset = (page - 1) * limit;

    let query = supabase
      .from('bookings')
      .select(`
        *,
        homeowners (
          homeowner_id,
          home_address
        ),
        services (
          service_id,
          name,
          description
        )
      `, { count: 'exact' })
      .eq('sp_id', sp_id)
      .in('status', ['pending', 'confirmed', 'in_progress'])
      .order('date', { ascending: true })
      .range(offset, offset + limit - 1);

    if (status) {
      query = query.eq('status', status);
    }

    const { data: bookings, error, count } = await query;

    if (error) {
      throw error;
    }

    res.json({
      bookings,
      pagination: {
        page: parseInt(page),
        limit: parseInt(limit),
        total: count,
        totalPages: Math.ceil(count / limit)
      }
    });
  } catch (error) {
    console.error('Get bookings error:', error);
    res.status(500).json({ error: 'Failed to fetch bookings' });
  }
};

const getBookingHistory = async (req, res) => {
  try {
    const sp_id = req.serviceProvider.sp_id;
    const { page = 1, limit = 20 } = req.query;
    const offset = (page - 1) * limit;

    const { data: bookings, error, count } = await supabase
      .from('bookings')
      .select(`
        *,
        homeowners (
          homeowner_id,
          home_address
        ),
        services (
          service_id,
          name
        ),
        reviews (
          review_id,
          rating,
          review_text
        )
      `, { count: 'exact' })
      .eq('sp_id', sp_id)
      .in('status', ['completed', 'cancelled'])
      .order('updated_at', { ascending: false })
      .range(offset, offset + limit - 1);

    if (error) {
      throw error;
    }

    res.json({
      bookings,
      pagination: {
        page: parseInt(page),
        limit: parseInt(limit),
        total: count,
        totalPages: Math.ceil(count / limit)
      }
    });
  } catch (error) {
    console.error('Get booking history error:', error);
    res.status(500).json({ error: 'Failed to fetch booking history' });
  }
};

const acceptBooking = async (req, res) => {
  try {
    const { bookingId } = req.params;
    const sp_id = req.serviceProvider.sp_id;

    const { data: booking, error: fetchError } = await supabase
      .from('bookings')
      .select('status')
      .eq('booking_id', bookingId)
      .eq('sp_id', sp_id)
      .single();

    if (fetchError || !booking) {
      return res.status(404).json({ error: 'Booking not found' });
    }

    if (booking.status !== 'pending') {
      return res.status(400).json({ error: 'Can only accept pending bookings' });
    }

    const { data: updatedBooking, error } = await supabase
      .from('bookings')
      .update({
        status: 'confirmed',
        updated_at: new Date().toISOString()
      })
      .eq('booking_id', bookingId)
      .select()
      .single();

    if (error) {
      throw error;
    }

    res.json({
      message: 'Booking accepted successfully',
      booking: updatedBooking
    });
  } catch (error) {
    console.error('Accept booking error:', error);
    res.status(500).json({ error: 'Failed to accept booking' });
  }
};

const declineBooking = async (req, res) => {
  try {
    const { bookingId } = req.params;
    const sp_id = req.serviceProvider.sp_id;

    const { data: booking, error: fetchError } = await supabase
      .from('bookings')
      .select('status')
      .eq('booking_id', bookingId)
      .eq('sp_id', sp_id)
      .single();

    if (fetchError || !booking) {
      return res.status(404).json({ error: 'Booking not found' });
    }

    if (booking.status !== 'pending') {
      return res.status(400).json({ error: 'Can only decline pending bookings' });
    }

    const { data: updatedBooking, error } = await supabase
      .from('bookings')
      .update({
        status: 'cancelled',
        updated_at: new Date().toISOString()
      })
      .eq('booking_id', bookingId)
      .select()
      .single();

    if (error) {
      throw error;
    }

    res.json({
      message: 'Booking declined successfully',
      booking: updatedBooking
    });
  } catch (error) {
    console.error('Decline booking error:', error);
    res.status(500).json({ error: 'Failed to decline booking' });
  }
};

const completeBooking = async (req, res) => {
  try {
    const { bookingId } = req.params;
    const sp_id = req.serviceProvider.sp_id;

    const { data: booking, error: fetchError } = await supabase
      .from('bookings')
      .select('status')
      .eq('booking_id', bookingId)
      .eq('sp_id', sp_id)
      .single();

    if (fetchError || !booking) {
      return res.status(404).json({ error: 'Booking not found' });
    }

    if (!['confirmed', 'in_progress'].includes(booking.status)) {
      return res.status(400).json({ error: 'Cannot complete this booking' });
    }

    const { data: updatedBooking, error } = await supabase
      .from('bookings')
      .update({
        status: 'completed',
        updated_at: new Date().toISOString()
      })
      .eq('booking_id', bookingId)
      .select()
      .single();

    if (error) {
      throw error;
    }

    res.json({
      message: 'Booking completed successfully',
      booking: updatedBooking
    });
  } catch (error) {
    console.error('Complete booking error:', error);
    res.status(500).json({ error: 'Failed to complete booking' });
  }
};

// Subscription
const getCurrentSubscription = async (req, res) => {
  try {
    const sp_id = req.serviceProvider.sp_id;

    const { data: subscription, error } = await supabase
      .from('subscriptions')
      .select('*')
      .eq('sp_id', sp_id)
      .eq('status', 'active')
      .single();

    if (error && error.code !== 'PGRST116') { // PGRST116 = no rows returned
      throw error;
    }

    res.json({ subscription: subscription || null });
  } catch (error) {
    console.error('Get subscription error:', error);
    res.status(500).json({ error: 'Failed to fetch subscription' });
  }
};

const upgradeSubscription = async (req, res) => {
  try {
    const { tier, payment_method } = req.body;
    const sp_id = req.serviceProvider.sp_id;

    // Define subscription pricing
    const pricing = {
      basic: 9.99,
      premium: 29.99,
      enterprise: 99.99
    };

    if (!pricing[tier]) {
      return res.status(400).json({ error: 'Invalid subscription tier' });
    }

    // Cancel existing active subscription
    await supabase
      .from('subscriptions')
      .update({ 
        status: 'cancelled',
        end_date: new Date().toISOString()
      })
      .eq('sp_id', sp_id)
      .eq('status', 'active');

    // Create new subscription
    const startDate = new Date();
    const endDate = new Date();
    endDate.setMonth(endDate.getMonth() + 1);

    const { data: subscription, error } = await supabase
      .from('subscriptions')
      .insert({
        sp_id,
        tier,
        price: pricing[tier],
        start_date: startDate.toISOString(),
        end_date: endDate.toISOString(),
        payment_method,
        status: 'active',
        created_at: new Date().toISOString()
      })
      .select()
      .single();

    if (error) {
      throw error;
    }

    res.json({
      message: 'Subscription upgraded successfully',
      subscription
    });
  } catch (error) {
    console.error('Upgrade subscription error:', error);
    res.status(500).json({ error: 'Failed to upgrade subscription' });
  }
};

// Profile
const getProfile = async (req, res) => {
  try {
    const sp_id = req.serviceProvider.sp_id;

    const { data: profile, error } = await supabase
      .from('service_providers')
      .select(`
        *,
        users (
          user_id,
          full_name,
          email,
          phone_number
        )
      `)
      .eq('sp_id', sp_id)
      .single();

    if (error) {
      throw error;
    }

    res.json({ profile });
  } catch (error) {
    console.error('Get profile error:', error);
    res.status(500).json({ error: 'Failed to fetch profile' });
  }
};

const updateProfile = async (req, res) => {
  try {
    const sp_id = req.serviceProvider.sp_id;
    const { working_address, service_type, experience_years, job_done, description } = req.body;

    const updates = {};
    if (working_address) updates.working_address = working_address;
    if (service_type) updates.service_type = service_type;
    if (experience_years !== undefined) updates.experience_years = experience_years;
    if (job_done !== undefined) updates.jobs_done = job_done;
    if (description) updates.description = description;

    const { data: profile, error } = await supabase
      .from('service_providers')
      .update(updates)
      .eq('sp_id', sp_id)
      .select()
      .single();

    if (error) {
      throw error;
    }

    res.json({
      message: 'Profile updated successfully',
      profile
    });
  } catch (error) {
    console.error('Update profile error:', error);
    res.status(500).json({ error: 'Failed to update profile' });
  }
};

module.exports = {
  addService,
  editService,
  deleteService,
  getMyServices,
  getDemands,
  getDemandDetails,
  sendOffer,
  getMyOffers,
  getOfferDetails,
  getMyBookings,
  getBookingHistory,
  acceptBooking,
  declineBooking,
  completeBooking,
  getCurrentSubscription,
  upgradeSubscription,
  getProfile,
  updateProfile,
 getDemandsByWilaya,
  getDemandsByCategory,
  searchDemandsByTitle,
  createCategory,getServiceById
  };
