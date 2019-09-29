from marshmallow import Schema, fields, validate
from serializer.base import BaseSchema, GenesisSchema, Timestamp


class ReducedUserSchema(GenesisSchema):
    id = fields.Str()
    username = fields.Str()
    picture_path = fields.Str()
    new_power = fields.Function(lambda obj: obj.vote_power + obj.content_power + obj.network_power)


class UserSchema(ReducedUserSchema):
    email = fields.Email()
    invited_by = fields.Str()
    invite_code = fields.Str()
    social = fields.Dict()
    bio = fields.Str()
    confirmed = fields.Bool()
    latitude = fields.Float()
    longitude = fields.Float()
    rank = fields.Int()
    referenced_from = fields.Str()


class FullUserSchema(UserSchema):
    vote_power = fields.Float()
    content_power = fields.Float()
    network_power = fields.Float()
    current_storage_bytes = fields.Float()
    max_storage_bytes = fields.Int()
    life_level = fields.Int()
