const express = require("express");
const router = express.Router();
const multer = require("multer");
const storage = multer.memoryStorage();
const upload = multer({ storage });



// Controllers
const {
  
  bookService ,getBookingOfUser
} = require("../controllers/booking");

const {
getServiceProviders , getServiceProviderProfile , getServices
} = require("../controllers/fetchServiceProvidersWilaya")

const {
uploadProfilePicture
} = require("../controllers/uploadProfilePictureSP")

const {
getAllServiceCategories
} = require("../controllers/categories")




router.post("/bookService",upload.array("photos", 5), bookService); 
router.get("/getBookingOfUser/:user_id", getBookingOfUser);      
router.get("/getServiceProviders" , getServiceProviders); 
router.post("/updateprofilephoto" ,upload.single('file'), uploadProfilePicture ) ; //to update profile photo for sp
router.get("/getServiceProviderProfile" , getServiceProviderProfile ); 
router.get("/getServices" , getServices );     
router.get("/categories" , getAllServiceCategories );


 



module.exports = router;
