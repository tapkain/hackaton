from flask.blueprints import Blueprint
from flask import jsonify, make_response
from webargs.flaskparser import use_args

import validation
import serializer
from repository import post_repository

bp = Blueprint('post', __name__, url_prefix='/api/post')


@bp.route('/')
@use_args(validation.PaginationRequestSchema())
def all_posts(args):
    p = post_repository.get_posts(**args)
    response_object = serializer.PostSchema(many=True).dump(p)
    return make_response(jsonify(response_object), 200)


@bp.route('/popular')
@use_args(validation.PaginationRequestSchema())
def popular_posts(args):
    p = post_repository.get_posts_popular(**args)
    response_object = serializer.PostSchema(many=True).dump(p)
    return make_response(jsonify(response_object), 200)
