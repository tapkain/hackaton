from marshmallow import Schema, fields, pre_load
from app.core.validation.base_validation import validate_username, PaginationRequestSchema, BaseRequestSchema
from config import const
from marshmallow_enum import EnumField


class DeviceSchema(Schema):
    id = fields.Str()
    ip = fields.Str()
    os = fields.Str(allow_none=True)
    os_version = fields.Str(allow_none=True)
    model = fields.Str(allow_none=True)
    instance_id = fields.Str(allow_none=True)
    app_version = fields.Str(allow_none=True)
    app_build_number = fields.Str(allow_none=True)
    is_rooted = fields.Bool(allow_none=True)
    is_simulator = fields.Bool(allow_none=True)


class UsersRequestSchema(PaginationRequestSchema):
    latitude = fields.Float()
    longitude = fields.Float()
    radius = fields.Float()
    username = fields.Str()
    confirmed = fields.Boolean()
    ranking_date = EnumField(const.RankingDateEnum, missing=const.RankingDateEnum.none)
    sort = fields.Method(deserialize='sort_method')

    def sort_method(self, sort):
        return const.UserSortEnum.from_string(sort)


class NewUserSchema(BaseRequestSchema):
    email = fields.Email(allow_none=True)
    # username = fields.Function(allow_none=True, deserialize=lambda x: x.lower() if x else None, validate=validate_username)
    invite_code = fields.Str(allow_none=True)
    social = fields.Str(allow_none=True)
    bio = fields.Str(allow_none=True)
    referenced_from = fields.Str(allow_none=True)
    latitude = fields.Float(allow_none=True)
    longitude = fields.Float(allow_none=True)
    location = fields.String(allow_none=True)
    device_info = fields.Nested(DeviceSchema, allow_none=True)


class ExistingUserSchema(BaseRequestSchema):
    username = fields.Function(deserialize=lambda x: x.lower().strip(), validate=validate_username, allow_none=True)
    email = fields.Email(allow_none=True)
    social = fields.Str(allow_none=True)
    bio = fields.Str(allow_none=True)
    latitude = fields.Float(allow_none=True)
    longitude = fields.Float(allow_none=True)
    invited_by = fields.Str(allow_none=True)
    device_info = fields.Nested(DeviceSchema, allow_none=True)


class VerifiedRequestSchema(Schema):
    trust_level = fields.Int(required=True)
