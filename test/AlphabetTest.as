package {
    import org.sqids.Sqids;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.text.TextField;
    import flash.text.TextFormat;

    public class AlphabetTest extends Sprite {
        private var outputField:TextField;

        public function AlphabetTest() {
            addEventListener(Event.ADDED_TO_STAGE, init);
        }

        private function init(event:Event):void {
            setupOutputField();
            runTests();
        }

        private function setupOutputField():void {
            outputField = new TextField();
            outputField.width = 550;
            outputField.height = 400;
            outputField.multiline = true;
            outputField.wordWrap = true;
            var format:TextFormat = new TextFormat();
            format.font = "Arial";
            format.size = 12;
            outputField.defaultTextFormat = format;
            addChild(outputField);
        }

        private function runTests():void {
            log("Running AlphabetTest...\n");
            testSimple();
            testShortAlphabet();
            testLongAlphabet();
            testMultibyteCharacters();
            testRepeatingAlphabetCharacters();
            testTooShortAlphabet();
            log("\nAll tests completed.");
        }

        private function testSimple():void {
            var sqids:Sqids = new Sqids({alphabet: "0123456789abcdef"});
            var numbers:Array = [1, 2, 3];
            var id:String = "489158";

            assertEquals(sqids.encode(numbers), id, "Simple encode test");
            assertArrayEquals(sqids.decode(id), numbers, "Simple decode test");
        }

        private function testShortAlphabet():void {
            var sqids:Sqids = new Sqids({alphabet: "abc"});
            var numbers:Array = [1, 2, 3];
            assertArrayEquals(sqids.decode(sqids.encode(numbers)), numbers, "Short alphabet test");
        }

        private function testLongAlphabet():void {
            var sqids:Sqids = new Sqids({alphabet: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()-_+|{}[];:'\"/?.>,<`~"});
            var numbers:Array = [1, 2, 3];
            assertArrayEquals(sqids.decode(sqids.encode(numbers)), numbers, "Long alphabet test");
        }

        private function testMultibyteCharacters():void {
            try {
                new Sqids({alphabet: "ë1092"});
                fail("Multibyte characters test");
            } catch (error:Error) {
                assertEquals(error.message, "Alphabet cannot contain multibyte characters", "Multibyte characters test");
            }
        }

        private function testRepeatingAlphabetCharacters():void {
            try {
                new Sqids({alphabet: "aabcdefg"});
                fail("Repeating alphabet characters test");
            } catch (error:Error) {
                assertEquals(error.message, "Alphabet must contain unique characters", "Repeating alphabet characters test");
            }
        }

        private function testTooShortAlphabet():void {
            try {
                new Sqids({alphabet: "ab"});
                fail("Too short alphabet test");
            } catch (error:Error) {
                assertEquals(error.message, "Alphabet length must be at least 3", "Too short alphabet test");
            }
        }

        private function assertEquals(actual:*, expected:*, message:String):void {
            if (actual !== expected) {
                log("FAIL: " + message + "\n  Expected: " + expected + "\n  Actual: " + actual);
            } else {
                log("PASS: " + message);
            }
        }

        private function assertArrayEquals(actual:Array, expected:Array, message:String):void {
            if (actual.length != expected.length) {
                log("FAIL: " + message + "\n  Arrays have different lengths");
                return;
            }
            for (var i:int = 0; i < actual.length; i++) {
                if (actual[i] !== expected[i]) {
                    log("FAIL: " + message + "\n  Arrays differ at index " + i + "\n  Expected: " + expected[i] + "\n  Actual: " + actual[i]);
                    return;
                }
            }
            log("PASS: " + message);
        }

        private function fail(message:String):void {
            log("FAIL: " + message + "\n  Expected exception was not thrown");
        }

        private function log(message:String):void {
            outputField.appendText(message + "\n");
            trace(message);
        }
    }
}
