
class Nft {
  int id;
  int img_id;
  int quality;
  int scape_id;
  int forum_point;
  int scape_points;
  int generation;
  String? name;
  String? wallet_address;
  String? description;
  String? full_description;

  Nft(this.scape_id, this.id, this.quality, this.img_id, this.forum_point, this.scape_points, this.generation, this.name, this.wallet_address, this.description, this.full_description);

  factory Nft.fromJson(Map<String, dynamic> json) {
    return Nft(
      json['scape_id'],
      json['id'],
      json['quality'],
      json['img_id'],
      json['forum_point'],
      json['scape_points'],
      json['generation'],
      json['name'],
      json['wallet_address'],
      json['description'],
      json['full_description'],
    );
  }

  String image() {
    return "https://seascape-cdn.oss-us-east-1.aliyuncs.com/nfts/$img_id.gif";
  }
}

class Resp {
  List<Nft> list;
  int page;
  int total_page;

  Resp(this.list, this.page, this.total_page);

  factory Resp.fromJson(Map<String, dynamic> json) {
    return Resp(
      (json['list'] as List<dynamic>).map((e) => Nft.fromJson(e)).toList(),
      json['page'],
      json['total_page'],
    );
  }
}