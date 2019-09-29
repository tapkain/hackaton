#include <eosio/eosio.hpp>

using namespace eosio;

class [[eosio::contract("newchain")]] newchain : public eosio::contract {

public:
  
  newchain(name receiver, name code,  datastream<const char*> ds): contract(receiver, code, ds) {}

  [[eosio::action]]
  void upsert(name user, name vote_id, name post_id, std::string content_type, std::string content_url, std::string user_id, name vote, double latitude, double longitude) {
    require_auth( user );
    vote_index votes( get_self(), get_first_receiver().value );
    auto iterator = votes.find(user.value);
    if( iterator == votes.end() )
    {
      votes.emplace(user, [&]( auto& row ) {
        row.vote_id = vote_id;
        row.post_id = post_id;
        row.content_url = content_url;
        row.content_type = content_type;
        row.user_id = user_id;
        row.vote = vote;
        row.longitude = longitude;
        row.latitude = latitude;
      });
    }
    else {
      votes.modify(iterator, user, [&]( auto& row ) {
        row.vote_id = vote_id;
        row.post_id = post_id;
        row.content_url = content_url;
        row.content_type = content_type;
        row.user_id = user_id;
        row.vote = vote;
        row.longitude = longitude;
        row.latitude = latitude;
      });
    }
  }

private:
  struct [[eosio::table]] vote {
    name vote_id;
    name post_id;
    std::string content_url;
    std::string content_type;
    std::string user_id;
    name vote;
    double longitude;
    double latitude;
    uint64_t primary_key() const { return vote_id.value; }
  };
  typedef eosio::multi_index<"votes"_n, vote> vote_index;

};