class Event {
  final int ticketingID;
  final int matchID;
  final String matchName;
  final String matchDate;
  final dynamic banner;
  final dynamic bannerMobile;
  final String sellingStartSate;
  final String sellingEndDate;
  final String homeTeam;
  final String homeLogo;
  final String awayTeam;
  final String awayLogo;
  final String locationName;
  final dynamic leagueName;
  final dynamic leagueLogo;

  const Event({
    required this.ticketingID,
    required this.matchID,
    required this.matchName,
    required this.matchDate,
    required this.banner,
    required this.bannerMobile,
    required this.sellingStartSate,
    required this.sellingEndDate,
    required this.homeTeam,
    required this.homeLogo,
    required this.awayTeam,
    required this.awayLogo,
    required this.locationName,
    required this.leagueName,
    required this.leagueLogo,
  });

  factory Event.fromJson(Map<String, dynamic> json) => Event(
        ticketingID: json['ticketing_id'],
        matchID: json['match_id'],
        matchName: json['match_name'],
        matchDate: json['match_date'],
        banner: json['banner'],
        bannerMobile: json['banner_mobile'],
        sellingStartSate: json['selling_start_date'],
        sellingEndDate: json['selling_end_date'],
        homeTeam: json['home_team'],
        homeLogo: json['home_logo'],
        awayTeam: json['away_team'],
        awayLogo: json['away_logo'],
        locationName: json['location_name'],
        leagueName: json['league_name'],
        leagueLogo: json['league_logo'],
      );

  Map<String, dynamic> toJson() => {
        'ticketing_id': ticketingID,
        'match_id': matchID,
        'match_name': matchName,
        'match_date': matchDate,
        'banner': banner,
        'banner_mobile': bannerMobile,
        'selling_start_date': sellingStartSate,
        'selling_end_date': sellingEndDate,
        'home_team': homeTeam,
        'home_logo': homeLogo,
        'away_team': awayTeam,
        'away_logo': awayLogo,
        'location_name': locationName,
        'league_name': leagueName,
        'league_logo': leagueLogo,
      };
}
