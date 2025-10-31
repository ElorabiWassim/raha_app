class Wilaya {
  final String name;
  final Map<String, List<String>> serviceProvidersByCategory;

  Wilaya({required this.name, required this.serviceProvidersByCategory});
}

List<Wilaya> wilayas = [
  //this is a dummy data , we still don't have real data
  Wilaya(
    name: "Algiers",
    serviceProvidersByCategory: {
      "Plumbing": ["PlumbCo", "AquaFix", "Wassim"],
      "Electrical": ["ElectroPro", "SparkTech", "DZKhaled"],
    },
  ),
  Wilaya(
    name: "Oran",
    serviceProvidersByCategory: {
      "Plumbing": ["PipeMasters", "FixIt"],
      "Electrical": ["VoltFix", "WireMasters"],
    },
  ),
  Wilaya(
    name: "Blida",
    serviceProvidersByCategory: {
      "Plumbing": ["WassimProMax", "RabahFix"],
      "Electrical": ["KhaledTriciti", "AmineMaster"],
    },
  ),
  Wilaya(
    name: "Tlemcen",
    serviceProvidersByCategory: {
      "Plumbing": ["WassimProMax", "RabahFix"],
      "Electrical": ["KhaledTriciti", "AmineMaster"],
    },
  ),
];
