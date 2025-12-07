const supabase = require('../config/supabase.js');

async function getAllServiceCategories(req, res) {
  try {
    const { data: categories, error } = await supabase
      .from('service_categories')
      .select('category_id, name'); 

    if (error) {
      console.error("Error fetching categories:", error);
      return res.status(500).json({ error: "Error fetching categories" });
    }

    return res.status(200).json(categories);

  } catch (err) {
    console.error("Server error:", err);
    return res.status(500).json({ error: "Server error" });
  }
}

module.exports = { getAllServiceCategories };
