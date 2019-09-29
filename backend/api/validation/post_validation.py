from marshmallow import Schema, fields, pre_load
from app.core.validation.base_validation import validate_username, PaginationRequestSchema, BaseRequestSchema
from config import const
from app.util import hashtag


class FeedRequestSchema(BaseRequestSchema):
    offset = fields.Int()
    per_page = fields.Int()

    ids = fields.Method(deserialize='ids_method')

    def ids_method(self, obj):
        return list(map(lambda x: int(x), obj.strip(',').split(',')))


class ExploreRequestSchema(PaginationRequestSchema):
    location = fields.Str()
    latitude = fields.Float()
    longitude = fields.Float()
    radius = fields.Float()
    hashtag = fields.Method(deserialize='hashtag_method')

    def hashtag_method(self, obj):
        return obj.strip(',').split(',')


class PostRequestSchema(PaginationRequestSchema):
    featured = fields.Boolean()
    repost = fields.Boolean()
    sort = fields.Method(deserialize='sort_method')

    def sort_method(self, sort):
        return const.PostSortEnum.from_string(sort)


class GetPostRequestSchema(ExploreRequestSchema, PostRequestSchema):
    user_id=fields.Str()
    filter=fields.Str()


class HashtagRequestSchema(PaginationRequestSchema):
    tag = fields.Str()


class VoteRequestSchema(BaseRequestSchema):
    vote = fields.Int(validate=lambda x: 0 <= x <= 20, required=True)
    reasons = fields.List(fields.Int(validate=lambda x: 0 <= x <= 50))


class TagSchema(BaseRequestSchema):
    reference_id = fields.Str()
    type = fields.Str()
    name = fields.Str()
    position_x = fields.Float()
    position_y = fields.Float()


class NewPostSchema(BaseRequestSchema):
    content_count = fields.Int(missing=0, allow_none=True, validate=lambda n: 0 <= n <= 10)

    featured = fields.Int(allow_none=True)
    parent_post_id = fields.Int(allow_none=True)
    description = fields.Str(allow_none=True)
    location = fields.Str(allow_none=True)
    latitude = fields.Float(allow_none=True)
    longitude = fields.Float(allow_none=True)

    type = fields.Str(allow_none=True)

    hashtags = fields.Function(deserialize=lambda x: list(set(map(lambda y: y.lower().strip(), hashtag.parse(x)))),
                               data_key='description')
    tags = fields.List(fields.Nested(TagSchema), allow_none=True)


class ExistingPostSchema(BaseRequestSchema):
    featured = fields.Int(allow_none=True)
    parent_post_id = fields.Int(allow_none=True)
    description = fields.Str(allow_none=True)
    location = fields.Str(allow_none=True)
    latitude = fields.Float(allow_none=True)
    longitude = fields.Float(allow_none=True)

    hashtags = fields.Function(deserialize=lambda x: list(set(map(lambda y: y.lower().strip(), hashtag.parse(x)))),
                               data_key='description')
    tags = fields.List(fields.Nested(TagSchema), allow_none=True)
