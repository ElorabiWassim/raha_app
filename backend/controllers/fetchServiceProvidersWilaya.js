const supabase = require('../config/supabase.js');


async function getServiceProviders(req, res) {
  try {
    const { location, category_id } = req.query;

    if (!location || !category_id) {
      return res.status(400).json({ error: "Location and category_id are required" });
    }

    // Fetch service providers along with their reviews
    const { data: providers, error } = await supabase
      .from('service_providers')
      .select(`
        sp_id,
        service_type_id:service_type,
        working_address,
        profile_picture_url,
        users:users!service_providers_sp_id_fkey (
          full_name,
          email
        ),
        service_type:service_type (
          name
        ),
        reviews:reviews!reviews_sp_id_fkey (
          rating
        )
      `)
      .ilike('working_address', `%${location}%`)
      .eq('service_type', category_id);

    if (error) {
      console.error("Error fetching providers:", error);
      return res.status(500).json({ error: "Error fetching providers" });
    }

    // Calculate average rating for each provider
    const providersWithAvg = providers.map(sp => {
      const ratings = sp.reviews.map(r => r.rating);
      const average_rating =
        ratings.length > 0
          ? ratings.reduce((sum, r) => sum + r, 0) / ratings.length
          : null;

      // Remove raw reviews from response if you only want average
      delete sp.reviews;

      return { ...sp, average_rating };
    });

    return res.status(200).json(providersWithAvg);

  } catch (err) {
    console.error("Server error:", err);
    return res.status(500).json({ error: "Server error" });
  }
}

async function getServiceProvidersTopN(req, res) {
  try {
    const { location, top_n } = req.query;

    if (!location) {
      return res.status(400).json({ error: "Location is required" });
    }

    // Fetch service providers along with their reviews
    const { data: providers, error } = await supabase
      .from('service_providers')
      .select(`
        sp_id,
        service_type_id:service_type,
        working_address,
        profile_picture_url,
        users:users!service_providers_sp_id_fkey (
          full_name,
          email
        ),
        service_type:service_type (
          name
        ),
        reviews:reviews!reviews_sp_id_fkey (
          rating
        )
      `)
      .ilike('working_address', `%${location}%`);
      

    if (error) {
      console.error("Error fetching providers:", error);
      return res.status(500).json({ error: "Error fetching providers" });
    }

    // Calculate average rating for each provider
    const providersWithAvg = providers.map(sp => {
      const ratings = sp.reviews.map(r => r.rating);
      const average_rating =
        ratings.length > 0
          ? ratings.reduce((sum, r) => sum + r, 0) / ratings.length
          : 0; // use 0 if no ratings

      delete sp.reviews; // remove raw reviews
      return { ...sp, average_rating };
    });

    // Sort by average rating descending
    const sortedProviders = providersWithAvg.sort((a, b) => b.average_rating - a.average_rating);

    // Return top N if top_n is provided
    const topProviders = top_n ? sortedProviders.slice(0, parseInt(top_n)) : sortedProviders;

    return res.status(200).json(topProviders);

  } catch (err) {
    console.error("Server error:", err);
    return res.status(500).json({ error: "Server error" });
  }
}

async function getServiceProviderProfile(req, res) {
  try {
    const { sp_id } = req.query; 

    if (!sp_id) {
      return res.status(400).json({ error: "sp_id is required" });
    }

    
    const { data: spData, error: spError } = await supabase
      .from('service_providers')
      .select(`
        sp_id,
        description,
        working_address,
        experience_years,
        jobs_done,
        profile_picture_url,
        users:users!service_providers_sp_id_fkey (
          full_name
        )
      `)
      .eq('sp_id', sp_id)
      .maybeSingle();

    if (spError || !spData) {
      console.error("Error fetching service provider:", spError);
      return res.status(404).json({ error: "Service provider not found" });
    }

    
    const { data: reviewsData, error: reviewError } = await supabase
      .from('reviews')
      .select('rating')
      .eq('sp_id', sp_id);

    let avgReview = null;
    let reviewPercentages = { "5": 0, "4": 0, "3": 0, "2": 0, "1": 0 };

    if (!reviewError && reviewsData.length > 0) {
      const totalReviews = reviewsData.length;
      const sumRatings = reviewsData.reduce((sum, r) => sum + r.rating, 0);
      avgReview = sumRatings / totalReviews;

      
      const counts = { "5": 0, "4": 0, "3": 0, "2": 0, "1": 0 };
      reviewsData.forEach(r => {
        const star = r.rating.toString();
        if (counts[star] !== undefined) counts[star]++;
      });

      
      for (let star in counts) {
        reviewPercentages[star] = Math.round((counts[star] / totalReviews) * 100);
      }
    }

    
    const profile = {
      sp_id: spData.sp_id,
      name: spData.users?.full_name || null,
      description: spData.description,
      average_review: avgReview,
      review_percentages: reviewPercentages,
      location: spData.working_address,
      jobs_done: spData.jobs_done,
      experience: spData.experience,
      profile_picture_url : spData.profile_picture_url
    };

    return res.status(200).json(profile);

  } catch (err) {
    console.error("Server error:", err);
    return res.status(500).json({ error: "Server error" });
  }
}

//this function to get the services of an sp
async function getServices(req, res) {
  try {
    const { sp_id } = req.query; 

    if (!sp_id) {
      return res.status(400).json({ error: "sp_id is required" });
    }

    
    const { data: services, error } = await supabase
      .from('services')
      .select(`
        service_id,
        name,
        price_amount,
        price_type,
        description
      `)
      .eq('sp_id', sp_id);

    if (error) {
      console.error("Error fetching services:", error);
      return res.status(500).json({ error: "Error fetching services" });
    }

    return res.status(200).json(services);

  } catch (err) {
    console.error("Server error:", err);
    return res.status(500).json({ error: "Server error" });
  }
}   

module.exports = { getServiceProviders , getServiceProviderProfile , getServices , getServiceProvidersTopN };


