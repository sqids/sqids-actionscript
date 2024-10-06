package {
    import org.sqids.Sqids;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.text.TextField;
    import flash.text.TextFormat;

    public class BlocklistTest extends Sprite {
        private var outputField:TextField;

        public function BlocklistTest() {
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
            log("Running BlocklistTest...\n");
            testDefaultBlocklist();
            testEmptyBlocklist();
            testCustomBlocklist();
            testBlocklist();
            testDecodingBlocklistWords();
            testShortBlocklistWord();
            testBlocklistFiltering();
            testMaxEncodingAttempts();
            log("\nAll tests completed.");
        }

        private function testDefaultBlocklist():void {
            var sqids:Sqids = new Sqids();
            assertArrayEquals(sqids.decode("aho1e"), [4572721], "Default blocklist decode test");
            assertEquals(sqids.encode([4572721]), "JExTR", "Default blocklist encode test");
        }

        private function testEmptyBlocklist():void {
            var sqids:Sqids = new Sqids({blocklist: []});
            assertArrayEquals(sqids.decode("aho1e"), [4572721], "Empty blocklist decode test");
            assertEquals(sqids.encode([4572721]), "aho1e", "Empty blocklist encode test");
        }

        private function testCustomBlocklist():void {
            var sqids:Sqids = new Sqids({blocklist: ["ArUO"]});
            assertArrayEquals(sqids.decode("aho1e"), [4572721], "Custom blocklist non-blocked decode test");
            assertEquals(sqids.encode([4572721]), "aho1e", "Custom blocklist non-blocked encode test");
            assertArrayEquals(sqids.decode("ArUO"), [100000], "Custom blocklist blocked decode test");
            assertEquals(sqids.encode([100000]), "QyG4", "Custom blocklist blocked encode test");
            assertArrayEquals(sqids.decode("QyG4"), [100000], "Custom blocklist new encode decode test");
        }

        private function testBlocklist():void {
            var sqids:Sqids = new Sqids({
                blocklist: [
                    "JSwXFaosAN",
                    "OCjV9JK64o",
                    "rBHf",
                    "79SM",
                    "7tE6"
                ]
            });
            assertEquals(sqids.encode([1000000, 2000000]), "1aYeB7bRUt", "Blocklist encode test");
            assertArrayEquals(sqids.decode("1aYeB7bRUt"), [1000000, 2000000], "Blocklist decode test");
        }

        private function testDecodingBlocklistWords():void {
            var sqids:Sqids = new Sqids({
                blocklist: ["86Rf07", "se8ojk", "ARsz1p", "Q8AI49", "5sQRZO"]
            });
            assertArrayEquals(sqids.decode("86Rf07"), [1, 2, 3], "Decoding blocklist word test 1");
            assertArrayEquals(sqids.decode("se8ojk"), [1, 2, 3], "Decoding blocklist word test 2");
            assertArrayEquals(sqids.decode("ARsz1p"), [1, 2, 3], "Decoding blocklist word test 3");
            assertArrayEquals(sqids.decode("Q8AI49"), [1, 2, 3], "Decoding blocklist word test 4");
            assertArrayEquals(sqids.decode("5sQRZO"), [1, 2, 3], "Decoding blocklist word test 5");
        }

        private function testShortBlocklistWord():void {
            var sqids:Sqids = new Sqids({blocklist: ["pnd"]});
            assertArrayEquals(sqids.decode(sqids.encode([1000])), [1000], "Short blocklist word test");
        }

        private function testBlocklistFiltering():void {
            var sqids:Sqids = new Sqids({
                alphabet: "ABCDEFGHIJKLMNOPQRSTUVWXYZ",
                blocklist: ["sxnzkl"] // Change this to an Array instead of a Vector.<String>
            });
            var id:String = sqids.encode([1, 2, 3]);
            var numbers:Array = sqids.decode(id);
            assertEquals(id, "IBSHOZ", "Blocklist filtering encode test");
            assertArrayEquals(numbers, [1, 2, 3], "Blocklist filtering decode test");
        }

        private function testMaxEncodingAttempts():void {
            var alphabet:String = "abc";
            var minLength:int = 3;
            var blocklist:Array = ["cab", "abc", "bca"];
            
            var sqids:Sqids = new Sqids({
                alphabet: alphabet,
                minLength: minLength,
                blocklist: blocklist
            });
            
            assertEquals(alphabet.length, minLength, "Alphabet length check");
            assertEquals(blocklist.length, minLength, "Blocklist length check");
            
            try {
                sqids.encode([0]);
                fail("Max encoding attempts test");
            } catch (error:Error) {
                assertEquals(error.message, "Reached max attempts to re-generate the ID", "Max encoding attempts error message");
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
