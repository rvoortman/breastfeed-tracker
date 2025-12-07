import Toybox.Lang;
using Toybox.Test;

(:test)
function testTrueEqualsTrue(logger as Test.Logger) as Boolean {
    logger.warning("warning");
    logger.debug("debug");
    logger.error("error");
    return 42 == 42;
}