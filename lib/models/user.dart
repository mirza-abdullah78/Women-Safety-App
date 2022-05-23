class User {
  String? id, firstName, lastName, phoneNumber, profilePhoto;
  Map? trusties, emergencyContacts;
  bool isAdmin;
  Map? lastLocation;

  User(this.id, this.firstName, this.lastName, this.phoneNumber, this.trusties,
      this.profilePhoto, this.emergencyContacts, this.isAdmin);

  Map<String, dynamic> toJson() => {
        '_id': id,
        'firstName': firstName,
        'lastName': lastName,
        'phoneNumber': phoneNumber,
        'trusties': trusties,
        'profilePhoto': profilePhoto,
        'emergencyContacts': emergencyContacts,
        'isAdmin': isAdmin
      };

  User.fromJson(Map<String, dynamic> jsonData)
      : id = jsonData['_id'],
        firstName = jsonData['firstName'],
        lastName = jsonData['lastName'],
        phoneNumber = jsonData['phoneNumber'],
        profilePhoto = jsonData['profilePhoto'],
        trusties = jsonData['trusties'],
        emergencyContacts = jsonData['emergencyContacts'],
        isAdmin = jsonData['isAdmin'] ?? false,
        lastLocation = jsonData['lastLocation'] ?? {};
}
