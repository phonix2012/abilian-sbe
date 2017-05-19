# FIXME: this test suite is passing but breaks some other tests.


# from datetime import datetime, timedelta
#
# import pytest
#
# import abilian.i18n
# from abilian.sbe.app import create_app
# from abilian.sbe.apps.communities.common import activity_time_format
#
#
# @pytest.fixture
# def app():
#     app = create_app()
#
#     # We need some incantations here to make babel work in the test
#     babel = abilian.i18n.babel
#     babel.locale_selector_func = None
#     babel.init_app(app)
#
#     return app
#
#
# def test_activity_time_format(app):
#
#     with app.app_context():
#         then = datetime(2017, 1, 1, 12, 0, 0)
#
#         now = then + timedelta(0, 5)
#         assert activity_time_format(then, now) == '5s'
#
#         now = then + timedelta(0, 5 * 60)
#         assert activity_time_format(then, now) == '5m'
#
#         now = then + timedelta(0, 5 * 60 * 60)
#         assert activity_time_format(then, now) == '5h'
#
#         now = then + timedelta(1, 5)
#         assert activity_time_format(then, now) == '1d'
#
#         now = then + timedelta(60, 5)
#         assert activity_time_format(then, now) == 'Jan 1'
#
#         now = then + timedelta(365 + 60, 5)
#         assert activity_time_format(then, now) == 'Jan 2017'
