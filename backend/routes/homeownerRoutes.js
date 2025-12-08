const express = require("express");
const router = express.Router();
const multer = require("multer");
const storage = multer.memoryStorage();
const upload = multer({ storage });
// const hoController = require('../controllers/ho.controller');
const { authenticate, isHomeowner } = require('../middlewares/auth.middleware');


// Controllers
const {

  bookService, getBookingOfUser
} = require("../controllers/booking");

const {
  getServiceProviders, getServiceProviderProfile, getServices
} = require("../controllers/fetchServiceProvidersWilaya")

const {
  uploadProfilePicture
} = require("../controllers/uploadProfilePictureSP")

const {
  getAllServiceCategories
} = require("../controllers/categories")

const {
  addDemand, editDemand, cancelDemand, getUserDemands, getDemandOffers, acceptDemand
} = require("../controllers/demands");




router.post("/bookService", upload.array("photos", 5), bookService);
router.get("/getBookingOfUser/:user_id", getBookingOfUser);
router.get("/getServiceProviders", getServiceProviders);
router.post("/updateprofilephoto", upload.single('file'), uploadProfilePicture); //to update profile photo for sp
router.get("/getServiceProviderProfile", getServiceProviderProfile);
router.get("/getServices", getServices);
router.get("/categories", getAllServiceCategories);
router.post("/addDemand", addDemand);
router.post("/editDemand", editDemand);
router.post("/cancelDemand", cancelDemand);
router.get("/getUserDemands", getUserDemands);
router.get("/getDemandOffers", getDemandOffers);
router.post("/acceptDemand", acceptDemand);

// router.post('/demands', authenticate, isHomeowner, hoController.createDemand);

module.exports = router;
