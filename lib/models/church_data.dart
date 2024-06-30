class Church {
  final int id;
  final String name;
  final String address;
  final String image;
  final String pastorImage;
  final String phone;
  final String email;
  final String website;
  final String fbHandle;
  final String iGHandle;
  final String twitterHandle;
  final String youTubeUrl;
  final String accountNumber1;
  final String accountNumber2;
  final String accountNumber3;

  double get latitude {
    return double.parse(address.split(', ').first);
  }

  double get longitude {
    return double.parse(address.split(', ').last);
  }

  Church({
    required this.id,
    required this.name,
    required this.address,
    required this.image,
    required this.pastorImage,
    required this.phone,
    required this.email,
    required this.website,
    required this.fbHandle,
    required this.iGHandle,
    required this.twitterHandle,
    required this.youTubeUrl,
    required this.accountNumber1,
    required this.accountNumber2,
    required this.accountNumber3,
  });

  factory Church.fromJson(Map json) {
    return Church(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      image: json['image'],
      pastorImage: json['pastorImage'],
      phone: json['phone'],
      email: json['email'],
      website: json['website'],
      fbHandle: json['fbHandle'],
      iGHandle: json['IGHandle'],
      twitterHandle: json['twitterHandle'],
      youTubeUrl: json['youTubeUrl'],
      accountNumber1: json['accountNumber1'],
      accountNumber2: json['accountNumber2'],
      accountNumber3: json['accountNumber3'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'image': image,
      'pastorImage': pastorImage,
      'phone': phone,
      'email': email,
      'website': website,
      'fbHandle': fbHandle,
      'IGHandle': iGHandle,
      'twitterHandle': twitterHandle,
      'youTubeUrl': youTubeUrl,
      'accountNumber1': accountNumber1,
      'accountNumber2': accountNumber2,
      'accountNumber3': accountNumber3,
    };
  }
}
