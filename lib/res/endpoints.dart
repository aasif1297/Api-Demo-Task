import '../../../res/base.dart';

class EndPoints {
  static const _base = BasePaths.baseUrl;
  static const postLogin = "$_base/Users/postlogin";
  static const getprofiledetails = "$_base/users/getprofiledetails";
  static const getEvents = "$_base/Events/getevents";
  static const getEventTypes = "$_base/Events/geteventtypes";
  static const getEventDetails = "$_base/Events/geteventdetails";
  static const getArtistGenre = "$_base/Events/getartistgenres";
  static const getArtists = "$_base/Events/getartists";
  static const getArtistDetail = "$_base/Events/getartistdetails";
  static const getVenues = "$_base/Events/getvenues";
  static const updatevenues = "$_base/events/updatevenues";
  static const getVenueDetails = "$_base/Events/getvenuedetails";
  static const updateuseraction = "$_base/users/updateuseraction";
  static const getnotifications = "$_base/users/getnotifications";
  static const marknotificationasread = "$_base/users/marknotificationasread";
  static const updateprofile = "$_base/users/updateprofile";
  static const getuseraction = "$_base/users/getuseraction";
  static const deviceUpdateSetting = "$_base/Devices/addorupdatedevice";
  static const deletedevice = "$_base/Devices/deletedevice";
  static const deleteAccount = "$_base/users/deleteAccount";
}
