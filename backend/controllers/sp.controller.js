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
        const { serviceId } = req.params;
        const sp_id = req.serviceProvider.sp_id;

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
            .eq('sp_id', sp_id)
            .single();

        if (error) {
            if (error.code === 'PGRST116') {

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

const getMyBookings = async (req, res) => {
    try {
        const sp_id = req.serviceProvider.sp_id;

        const { data: bookings, error } = await supabase
            .from('bookings')
            .select(`
        *,
        services (
          service_id,
          name,
          category_id,
          service_categories (
            category_id,
            name
          )
        ),
        homeowners!inner (
          homeowner_id,
          home_address,
          date_of_birth,
          users!inner (
            user_id,
            full_name,
            phone_number,
            email
          )
        ),
        booking_images (
          booking_image_id,
          image_url
        )
      `)
            .eq('sp_id', sp_id)
            .order('created_at', { ascending: false });

        if (error) {
            console.error('Supabase error:', error);
            throw error;
        }

        res.json({ bookings });
    } catch (error) {
        console.error('Get my bookings error:', error);
        res.status(500).json({ error: 'Failed to fetch bookings' });
    }
};

const getBookingHistory = async (req, res) => {
    try {
        console.log('📋 Getting booking history...');
        console.log('Service Provider:', req.serviceProvider);

        const sp_id = req.serviceProvider.sp_id;
        const { page = 1, limit = 20 } = req.query;
        const offset = (page - 1) * limit;

        const tenDaysAgo = new Date();
        tenDaysAgo.setDate(tenDaysAgo.getDate() - 10);

        console.log('Query params:', { sp_id, page, limit, offset, tenDaysAgo: tenDaysAgo.toISOString() });

        const { data: bookings, error, count } = await supabase
            .from("bookings")
            .select(`
        *,
        homeowners!inner (
          homeowner_id,
          home_address,
          date_of_birth,
          users!inner (
            user_id,
            full_name,
            phone_number,
            email
          )
        ),
        services (
          service_id,
          name,
          category_id,
          service_categories (
            category_id,
            name
          )
        ),
        booking_images (
          booking_image_id,
          image_url
        )
      `, { count: "exact" })
            .eq("sp_id", sp_id)
            .in("status", ["completed", "cancelled", "rejected"])
            .gte("updated_at", tenDaysAgo.toISOString())
            .order("updated_at", { ascending: false })
            .range(offset, offset + limit - 1);

        if (error) {
            console.error('❌ Supabase error details:', JSON.stringify(error, null, 2));
            throw error;
        }

        console.log('✅ Bookings fetched:', bookings?.length || 0);

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
        console.error("❌ Get booking history error:", error);
        console.error("Error message:", error.message);
        console.error("Error details:", JSON.stringify(error, null, 2));
        res.status(500).json({ error: "Failed to fetch booking history", details: error.message });
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
                status: 'accepted',
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
                status: 'rejected',
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

        if (booking.status !== 'accepted') {
            return res.status(400).json({ error: 'Can only complete accepted bookings' });
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

module.exports = {
    getMyBookings,
    getBookingHistory,
    acceptBooking,
    declineBooking,
    completeBooking
};

const getCurrentSubscription = async (req, res) => {
    try {
        const sp_id = req.serviceProvider.sp_id;

        const { data: subscription, error } = await supabase
            .from('subscriptions')
            .select('*')
            .eq('sp_id', sp_id)
            .eq('status', 'active')
            .single();

        if (error && error.code !== 'PGRST116') {
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
            free: 0.00,
            pro: 2999,
            elite: 9999
        };

        if (!pricing[tier]) {
            return res.status(400).json({ error: 'Invalid subscription tier' });
        }

        await supabase
            .from('subscriptions')
            .update({
                status: 'cancelled',
                end_date: new Date().toISOString()
            })
            .eq('sp_id', sp_id)
            .eq('status', 'active');

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
        const { working_address, service_type, experience_years, job_done, description, verificationstatus } = req.body;

        const updates = {};
        if (working_address) updates.working_address = working_address;
        if (service_type) updates.service_type = service_type;
        if (experience_years !== undefined) updates.experience_years = experience_years;
        if (job_done !== undefined) updates.jobs_done = job_done;
        if (description) updates.description = description;
        if (verificationstatus) updates.verification_status = verificationstatus;

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

const uploadServiceImages = async (req, res) => {
    try {
        const { service_id } = req.params;
        const sp_id = req.serviceProvider.sp_id;

        // Validate service ownership
        const { data: service, error: serviceError } = await supabase
            .from('services')
            .select('service_id, sp_id')
            .eq('service_id', service_id)
            .eq('sp_id', sp_id)
            .single();

        if (serviceError || !service) {
            return res.status(404).json({ error: 'Service not found or unauthorized' });
        }

        const images = req.files || [];
        const savedImagePaths = []; // ← Store paths, not URLs

        for (const image of images) {
            const timestamp = Date.now();
            const filename = `${service_id}_${timestamp}_${image.originalname}`;
            const filePath = `service-images/${sp_id}/${filename}`; // 👈 This is what we save

            // Upload to Supabase Storage
            const { error: uploadError } = await supabase.storage
                .from('service-images')
                .upload(filePath, image.buffer, {
                    contentType: image.mimetype,
                    upsert: false
                });

            if (uploadError) {
                console.error('Upload error:', uploadError);
                continue;
            }

            // ✅ SAVE ONLY THE FILE PATH (NOT URL!)
            const { data: imageRecord, error: dbError } = await supabase
                .from('service_images')
                .insert({
                    service_id,
                    image_url: filePath // 👈 Critical: store path, not publicUrl
                })
                .select()
                .single();

            if (!dbError) {
                savedImagePaths.push(imageRecord);
            }
        }

        res.status(201).json({
            message: 'Images uploaded successfully',
            images: savedImagePaths
        });

    } catch (error) {
        console.error('Upload service images error:', error);
        res.status(500).json({ error: 'Failed to upload images' });
    }
};


// GET /services/:service_id/images
const getServiceImages = async (req, res) => {
    try {
        const { service_id } = req.params;

        const { data: images, error } = await supabase
            .from('service_images')
            .select('image_id, image_url') // image_url = filename/path
            .eq('service_id', service_id);

        if (error) throw error;

        // Generate fresh signed URLs for each image
        const signedImages = await Promise.all(
            images.map(async (img) => {
                const fileName = img.image_url; // ← This is just the filename/path

                const { data: signedUrlData } = await supabase.storage
                    .from('service-images')
                    .createSignedUrl(fileName, 60 * 5);

                return {
                    ...img,
                    image_url: signedUrlData.signedUrl
                };
            })
        );

        res.status(200).json({
            service_id,
            images: signedImages
        });

    } catch (error) {
        console.error('Get service images error:', error);
        res.status(500).json({ error: 'Failed to fetch images' });
    }
};

const deleteServiceImage = async (req, res) => {
    try {
        const { image_id } = req.params;
        const sp_id = req.serviceProvider.sp_id;
        const { data: image, error: imageError } = await supabase
            .from('service_images')
            .select(`
        *,
        services!inner(sp_id)
      `)
            .eq('image_id', image_id)
            .single();

        if (imageError || !image) {
            return res.status(404).json({ error: 'Image not found' });
        }

        if (image.services.sp_id !== sp_id) {
            return res.status(403).json({ error: 'Unauthorized' });
        }

        // Extract file path from URL
        const url = new URL(image.image_url);
        const filePath = url.pathname.split('/storage/v1/object/public/service-images/')[1];

        const { error: storageError } = await supabase.storage
            .from('service-images')
            .remove([filePath]);

        if (storageError) {
            console.error('Storage delete error:', storageError);
        }


        const { error: dbError } = await supabase
            .from('service_images')
            .delete()
            .eq('image_id', image_id);

        if (dbError) {
            throw dbError;
        }

        res.status(200).json({
            message: 'Image deleted successfully'
        });
    } catch (error) {
        console.error('Delete service image error:', error);
        res.status(500).json({ error: 'Failed to delete image' });
    }
};
const updateServiceImage = async (req, res) => {
    try {
        const { image_id } = req.params;
        const sp_id = req.serviceProvider.sp_id;
        const newImage = req.file;

        if (!newImage) {
            return res.status(400).json({ error: 'No image provided' });
        }

        const { data: existingImage, error: imageError } = await supabase
            .from('service_images')
            .select(`
        *,
        services!inner(sp_id, service_id)
      `)
            .eq('image_id', image_id)
            .single();

        if (imageError || !existingImage) {
            return res.status(404).json({ error: 'Image not found' });
        }

        if (existingImage.services.sp_id !== sp_id) {
            return res.status(403).json({ error: 'Unauthorized' });
        }
        const oldUrl = new URL(existingImage.image_url);
        const oldFilePath = oldUrl.pathname.split('/storage/v1/object/public/service-images/')[1];

        await supabase.storage
            .from('service-images')
            .remove([oldFilePath]);


        const timestamp = Date.now();
        const filename = `${existingImage.services.service_id}_${timestamp}_${newImage.originalname}`;
        const newFilePath = `service-images/${sp_id}/${filename}`;

        const { data: uploadData, error: uploadError } = await supabase.storage
            .from('service-images')
            .upload(newFilePath, newImage.buffer, {
                contentType: newImage.mimetype,
                upsert: false
            });

        if (uploadError) {
            throw uploadError;
        }


        const { data: urlData } = supabase.storage
            .from('service-images')
            .getPublicUrl(newFilePath);


        const { data: updatedImage, error: updateError } = await supabase
            .from('service_images')
            .update({
                image_url: urlData.publicUrl,
                updated_at: new Date().toISOString()
            })
            .eq('image_id', image_id)
            .select()
            .single();

        if (updateError) {
            throw updateError;
        }

        res.status(200).json({
            message: 'Image updated successfully',
            image: updatedImage
        });
    } catch (error) {
        console.error('Update service image error:', error);
        res.status(500).json({ error: 'Failed to update image' });
    }
};

const updateProfilePicture = async (req, res) => {
    try {
        const sp_id = req.serviceProvider.sp_id;
        const image = req.file;

        if (!image) {
            return res.status(400).json({ error: 'No image provided' });
        }

        const { data: currentProfile, error: profileError } = await supabase
            .from('service_providers')
            .select('profile_picture_url')
            .eq('sp_id', sp_id)
            .single();

        if (profileError) {
            throw profileError;
        }
        if (currentProfile.profile_picture_url) {
            try {
                const oldUrl = new URL(currentProfile.profile_picture_url);
                const oldFilePath = oldUrl.pathname.split('/storage/v1/object/public/service-providers-profile-photos/')[1];

                if (oldFilePath) {
                    await supabase.storage
                        .from('service-providers-profile-photos')
                        .remove([oldFilePath]);
                }
            } catch (deleteError) {
                console.error('Error deleting old profile picture:', deleteError);

            }
        }

        const timestamp = Date.now();
        const fileExtension = image.originalname.split('.').pop();
        const filename = `${sp_id}_${timestamp}.${fileExtension}`;
        const filePath = `${sp_id}/${filename}`;

        const { data: uploadData, error: uploadError } = await supabase.storage
            .from('service-providers-profile-photos')
            .upload(filePath, image.buffer, {
                contentType: image.mimetype,
                upsert: false
            });

        if (uploadError) {
            throw uploadError;
        }

        const { data: urlData } = supabase.storage
            .from('service-providers-profile-photos')
            .getPublicUrl(filePath);

        const { data: updatedProfile, error: updateError } = await supabase
            .from('service_providers')
            .update({
                profile_picture_url: urlData.publicUrl
            })
            .eq('sp_id', sp_id)
            .select()
            .single();

        if (updateError) {
            throw updateError;
        }

        res.json({
            message: 'Profile picture updated successfully',
            profile_picture_url: urlData.publicUrl,
            profile: updatedProfile
        });
    } catch (error) {
        console.error('Update profile picture error:', error);
        res.status(500).json({ error: 'Failed to update profile picture' });
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
    createCategory, getServiceById,
    getServiceImages,
    uploadServiceImages,
    deleteServiceImage,
    updateServiceImage,
    updateProfilePicture
};
