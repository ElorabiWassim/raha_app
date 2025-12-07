const supabase = require('../config/supabase.js');


async function addDemand(req, res) {
  try {
    const { 
      homeowner_id, 
      category_name, 
      title, 
      location, 
      date, 
      time, 
      description 
    } = req.body;

    if (!homeowner_id || !category_name || !title || !location || !date || !time || !description) {
      return res.status(400).json({ error: "All fields are required" });
    }

    const { data: categoryData, error: categoryError } = await supabase
      .from('service_categories')
      .select('category_id')
      .eq('name', category_name)
      .maybeSingle();

    if (categoryError || !categoryData) {
      return res.status(400).json({ error: "Invalid category name" });
    }

    const category_id = categoryData.category_id;

    const { data: newDemand, error: insertError } = await supabase
      .from('demands')
      .insert({
        homeowner_id,
        category_id,
        title,
        location,
        date,
        time,
        description
      })
      .select()
      .maybeSingle();

    if (insertError) {
      console.error("Error inserting demand:", insertError);
      return res.status(500).json({ error: "Error adding demand" });
    }

    return res.status(201).json({
      message: "Demand added successfully",
      demand: newDemand
    });

  } catch (err) {
    console.error("Server error:", err);
    return res.status(500).json({ error: "Server error" });
  }
}


async function editDemand(req, res) {
  try {
    const { demand_id, title, location, date, time, description, category_name } = req.body;

    if (!demand_id) {
      return res.status(400).json({ error: "demand_id is required" });
    }

    let category_id;
    if (category_name) {
      const { data: categoryData, error: categoryError } = await supabase
        .from('service_categories')
        .select('category_id')
        .eq('name', category_name)
        .maybeSingle();

      if (categoryError || !categoryData) {
        return res.status(400).json({ error: "Invalid category name" });
      }

      category_id = categoryData.category_id;
    }

    const updateData = {};
    if (title) updateData.title = title;
    if (location) updateData.location = location;
    if (date) updateData.date = date;
    if (time) updateData.time = time;
    if (description) updateData.description = description;
    if (category_id) updateData.category_id = category_id;

    const { data, error } = await supabase
      .from('demands')
      .update(updateData)
      .eq('demand_id', demand_id)
      .select()
      .maybeSingle();

    if (error) {
      console.error("Error updating demand:", error);
      return res.status(500).json({ error: "Error updating demand" });
    }

    return res.status(200).json({
      message: "Demand updated successfully",
      demand: data
    });

  } catch (err) {
    console.error("Server error:", err);
    return res.status(500).json({ error: "Server error" });
  }
}


async function cancelDemand(req, res) {
  try {
    const { demand_id } = req.body;

    if (!demand_id) {
      return res.status(400).json({ error: "demand_id is required" });
    }

    const { data, error } = await supabase
      .from('demands')
      .delete()
      .eq('demand_id', demand_id)
      .select();

    if (error) {
      console.error("Error canceling demand:", error);
      return res.status(500).json({ error: "Error canceling demand" });
    }

    return res.status(200).json({
      message: "Demand canceled successfully",
      demand: data
    });

  } catch (err) {
    console.error("Server error:", err);
    return res.status(500).json({ error: "Server error" });
  }
}

async function getUserDemands(req, res) {
  try {
    const { homeowner_id } = req.query;

    if (!homeowner_id) {
      return res.status(400).json({ error: "homeowner_id is required" });
    }

    const { data, error } = await supabase
      .from('demands')
      .select(`
        demand_id,
        title,
        description,
        location,
        date,
        time,
        status,
        service_categories:category_id (
          name
        )
      `)
      .eq('homeowner_id', homeowner_id)
      .order('date', { ascending: true }); 

    if (error) {
      console.error("Error fetching demands:", error);
      return res.status(500).json({ error: "Error fetching demands" });
    }

    return res.status(200).json(data);

  } catch (err) {
    console.error("Server error:", err);
    return res.status(500).json({ error: "Server error" });
  }
}


async function getDemandOffers(req, res) {
  try {
    const { demand_id } = req.query;

    if (!demand_id) {
      return res.status(400).json({ error: "demand_id is required" });
    }

    // Fetch offers for the demand
    const { data, error } = await supabase
      .from('demand_offers')
      .select(`
        offer_id,
        message,
        proposed_price,
        proposed_date,
        sp_id,
        service_providers:sp_id (
          users:users!service_providers_sp_id_fkey (
            full_name
          )
        )
      `)
      .eq('demand_id', demand_id)
      .order('proposed_date', { ascending: true });

    if (error) {
      console.error("Error fetching demand offers:", error);
      return res.status(500).json({ error: "Error fetching demand offers" });
    }

    const formatted = data.map(offer => ({
      offer_id: offer.offer_id,
      message: offer.message,
      proposed_price: offer.proposed_price,
      proposed_date: offer.proposed_date,
      sp_id: offer.sp_id,
      sp_name: offer.service_providers?.users?.full_name || null,
    }));

    return res.status(200).json(formatted);

  } catch (err) {
    console.error("Server error:", err);
    return res.status(500).json({ error: "Server error" });
  }
}


async function acceptDemand(req, res) {
  try {
    const { demand_id, sp_id } = req.body;

    if (!demand_id || !sp_id) {
      return res.status(400).json({ error: "demand_id and sp_id are required" });
    }

    const { data, error } = await supabase
      .from('demands')
      .update({
        selected_sp_id: sp_id,
        status: 'matched'
      })
      .eq('demand_id', demand_id)
      .select()
      .maybeSingle();

    if (error) {
      console.error("Error updating demand:", error);
      return res.status(500).json({ error: "Error updating demand" });
    }

    if (!data) {
      return res.status(404).json({ error: "Demand not found" });
    }

    return res.status(200).json({
      message: "Demand accepted successfully",
      demand: data
    });

  } catch (err) {
    console.error("Server error:", err);
    return res.status(500).json({ error: "Server error" });
  }
}






module.exports = { addDemand , editDemand , cancelDemand , getUserDemands , getDemandOffers , acceptDemand };
