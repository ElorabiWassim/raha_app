const supabase = require('../config/supabase');
const getreviewsById = async (req, res) => {
  try {
    const { sp_id } = req.params; 

    const { data: reviews, error } = await supabase
      .from('reviews')
      .select(`
        * 
      `)
      .eq('sp_id', sp_id);
      

    if (error) {
      if (error.code === 'PGRST116') {
       
        return res.status(404).json({ error: 'Reviews not found or access denied' });
      }
      throw error;
    }

    res.json({ reviews });
  } catch (error) {
    console.error('Get review by ID error:', error);
    res.status(500).json({ error: 'Failed to fetch reviews' });
  }
};
const getServiceByspId = async (req, res) => {
  try {
    const { sp_id } = req.params; 

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


module.exports = {
  getreviewsById,getServiceByspId
};