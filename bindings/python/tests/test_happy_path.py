from cyclonedx_example import library_function


def test_happy_path():
    assert library_function(3) == "3"
