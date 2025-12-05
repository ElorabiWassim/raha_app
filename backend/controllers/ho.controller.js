const supabase = require('../config/supabase');
const createDemand = async (req, res) => {
  try {
    const { title, description, category_id, location, date, time, status = 'open' } = req.body;

    // Validate required fields
    if (!title || !category_id || !location) {
      return res.status(400).json({ error: 'Missing required fields' });
    }

    // Get homeowner ID from authenticated user (assuming you're using homeowner auth)
    const homeowner_id = req.user.user_id; // Set by authenticate middleware

    // Insert demand
    const { data: newDemand, error } = await supabase
      .from('demands')
      .insert({
        homeowner_id,
        category_id,
        title,
        description,
        location,
        date,
        time,
        status,
        created_at: new Date().toISOString()
      })
      .select()
      .single();

    if (error) {
      throw error;
    }

    res.status(201).json({
      message: 'Demand created successfully',
      demand: newDemand
    });

  } catch (error) {
    console.error('Create demand error:', error);
    res.status(500).json({ error: 'Failed to create demand' });
  }
};

module.exports = {
  createDemand
};