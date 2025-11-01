import '../models/service_provider_model.dart';

class Wilaya {
  final String name;
  final Map<String, List<ServiceProvider>> serviceProvidersByCategory;

  Wilaya({required this.name, required this.serviceProvidersByCategory});
}

// Sample data - replace with real data from your backend
List<Wilaya> wilayas = [
  Wilaya(
    name: "Algiers",
    serviceProvidersByCategory: {
      "Plumbing": [
        ServiceProvider(
          name: "Amjad axlo",
          profession: "Master Plumber",
          location: "Algiers, Draria",
          rating: 4.9,
          reviewCount: 125,
          jobsDone: "150+",
          experience: "10 yrs",
          responseTime: "< 1hr",
          pendingRequests: 5,
          confirmedJobs: 3,
          totalEarnings: 50000,
          imagePath: "assets/images/alexo.png",
          services: [
            Service(
              title: "Leak Detection & Repair",
              price: "1300 Da",
              isActive: true,
              category: "Plumbing",
              description: "Professional leak detection and repair services",
              pricingModel: "Starts at",
            ),
            Service(
              title: "Drain Cleaning",
              price: "2500 Da",
              isActive: true,
              category: "Plumbing",
              description: "Complete drain cleaning service",
              pricingModel: "Per hour",
            ),
            Service(
              title: "Water Heater Installation",
              price: "5000 Da",
              isActive: true,
              category: "Plumbing",
              description: "Water heater installation and maintenance",
              pricingModel: "Starts at",
            ),
          ],
        ),
        ServiceProvider(
          name: "Wassim Pro",
          profession: "Plumber",
          location: "Algiers, Bab Ezzouar",
          rating: 4.7,
          reviewCount: 89,
          jobsDone: "100+",
          experience: "7 yrs",
          responseTime: "< 2hr",
          pendingRequests: 3,
          confirmedJobs: 2,
          totalEarnings: 35000,
          imagePath: "assets/images/JohnDoe.png",
          services: [
            Service(
              title: "Pipe Installation",
              price: "1500 Da",
              isActive: true,
              category: "Plumbing",
              description: "Professional pipe installation",
              pricingModel: "Starts at",
            ),
          ],
        ),
      ],
      "Electrical": [
        ServiceProvider(
          name: "Khaled ElectroPro",
          profession: "Licensed Electrician",
          location: "Algiers, Hydra",
          rating: 4.8,
          reviewCount: 98,
          jobsDone: "120+",
          experience: "8 yrs",
          responseTime: "< 1hr",
          pendingRequests: 4,
          confirmedJobs: 2,
          totalEarnings: 45000,
          imagePath: "assets/images/JohnDoe.png",
          services: [
            Service(
              title: "Electrical Wiring",
              price: "2000 Da",
              isActive: true,
              category: "Electrical",
              description: "Complete electrical wiring solutions",
              pricingModel: "Per hour",
            ),
          ],
        ),
      ],
    },
  ),
  Wilaya(
    name: "Oran",
    serviceProvidersByCategory: {
      "Plumbing": [
        ServiceProvider(
          name: "Ahmed PipeMaster",
          profession: "Plumber",
          location: "Oran, Centre Ville",
          rating: 4.6,
          reviewCount: 75,
          jobsDone: "90+",
          experience: "6 yrs",
          responseTime: "< 3hr",
          pendingRequests: 2,
          confirmedJobs: 1,
          totalEarnings: 28000,
          imagePath: "assets/images/JohnDoe.png",
          services: [
            Service(
              title: "Emergency Plumbing",
              price: "1800 Da",
              isActive: true,
              category: "Plumbing",
              description: "24/7 emergency plumbing service",
              pricingModel: "Per hour",
            ),
          ],
        ),
      ],
      "Electrical": [
        ServiceProvider(
          name: "Yacine VoltFix",
          profession: "Electrician",
          location: "Oran, Es Senia",
          rating: 4.5,
          reviewCount: 62,
          jobsDone: "80+",
          experience: "5 yrs",
          responseTime: "< 2hr",
          pendingRequests: 1,
          confirmedJobs: 3,
          totalEarnings: 22000,
          imagePath: "assets/images/JohnDoe.png",
          services: [
            Service(
              title: "Electrical Repairs",
              price: "1500 Da",
              isActive: true,
              category: "Electrical",
              description: "All types of electrical repairs",
              pricingModel: "Starts at",
            ),
          ],
        ),
      ],
    },
  ),
  Wilaya(
    name: "Blida",
    serviceProvidersByCategory: {
      "Plumbing": [
        ServiceProvider(
          name: "Rabah FixIt",
          profession: "Master Plumber",
          location: "Blida, Centre",
          rating: 4.7,
          reviewCount: 55,
          jobsDone: "70+",
          experience: "9 yrs",
          responseTime: "< 1hr",
          pendingRequests: 2,
          confirmedJobs: 2,
          totalEarnings: 30000,
          imagePath: "assets/images/JohnDoe.png",
          services: [
            Service(
              title: "Bathroom Plumbing",
              price: "2500 Da",
              isActive: true,
              category: "Plumbing",
              description: "Complete bathroom plumbing services",
              pricingModel: "Starts at",
            ),
          ],
        ),
      ],
    },
  ),
];