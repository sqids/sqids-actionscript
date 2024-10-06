package {
    import org.sqids.Sqids;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.text.TextField;
    import flash.text.TextFormat;

    public class EncodingTest extends Sprite {
        private var outputField:TextField;

        public function EncodingTest() {
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
            log("Running EncodingTest...\n");
            testSimple();
            testDifferentInputs();
            testIncrementalNumbers();
            testIncrementalNumbersSameIndex0();
            testIncrementalNumbersSameIndex1();
            testMultiInput();
            testEncodingNoNumbers();
            testDecodingEmptyString();
            testDecodingInvalidCharacter();
            log("\nAll tests completed.");
        }

        private function testSimple():void {
            var sqids:Sqids = new Sqids();
            var numbers:Array = [1, 2, 3];
            var id:String = "86Rf07";

            assertEquals(sqids.encode(numbers), id, "Simple encode test");
            assertArrayEquals(sqids.decode(id), numbers, "Simple decode test");
        }

        private function testDifferentInputs():void {
            var numbers:Array = [0, 0, 0, 1, 2, 3, 100, 1000, 100000, 1000000, 4294967294];
            var sqids:Sqids = new Sqids();
            assertArrayEquals(sqids.decode(sqids.encode(numbers)), numbers, "Different inputs test");
        }

        private function testIncrementalNumbers():void {
            var sqids:Sqids = new Sqids();
            var ids:Object = {
                bM: [0],
                Uk: [1],
                gb: [2],
                Ef: [3],
                Vq: [4],
                uw: [5],
                OI: [6],
                AX: [7],
                p6: [8],
                nJ: [9]
            };

            for (var id:String in ids) {
                var numbers:Array = ids[id];
                assertEquals(sqids.encode(numbers), id, "Incremental numbers encode test for " + id);
                assertArrayEquals(sqids.decode(id), numbers, "Incremental numbers decode test for " + id);
            }
        }

        private function testIncrementalNumbersSameIndex0():void {
            var sqids:Sqids = new Sqids();
            var ids:Object = {
                SvIz: [0, 0],
                n3qa: [0, 1],
                tryF: [0, 2],
                eg6q: [0, 3],
                rSCF: [0, 4],
                sR8x: [0, 5],
                uY2M: [0, 6],
                "74dI": [0, 7],
                "30WX": [0, 8],
                moxr: [0, 9]
            };

            for (var id:String in ids) {
                var numbers:Array = ids[id];
                assertEquals(sqids.encode(numbers), id, "Incremental numbers same index 0 encode test for " + id);
                assertArrayEquals(sqids.decode(id), numbers, "Incremental numbers same index 0 decode test for " + id);
            }
        }

        private function testIncrementalNumbersSameIndex1():void {
            var sqids:Sqids = new Sqids();
            var ids:Object = {
                SvIz: [0, 0],
                nWqP: [1, 0],
                tSyw: [2, 0],
                eX68: [3, 0],
                rxCY: [4, 0],
                sV8a: [5, 0],
                uf2K: [6, 0],
                "7Cdk": [7, 0],
                "3aWP": [8, 0],
                m2xn: [9, 0]
            };

            for (var id:String in ids) {
                var numbers:Array = ids[id];
                assertEquals(sqids.encode(numbers), id, "Incremental numbers same index 1 encode test for " + id);
                assertArrayEquals(sqids.decode(id), numbers, "Incremental numbers same index 1 decode test for " + id);
            }
        }

        private function testMultiInput():void {
            var sqids:Sqids = new Sqids();
            var numbers:Array = [];
            for (var i:int = 0; i < 100; i++) {
                numbers.push(i);
            }
            var output:Array = sqids.decode(sqids.encode(numbers));
            assertArrayEquals(numbers, output, "Multi input test");
        }

        private function testEncodingNoNumbers():void {
            var sqids:Sqids = new Sqids();
            assertEquals(sqids.encode([]), "", "Encoding no numbers test");
        }

        private function testDecodingEmptyString():void {
            var sqids:Sqids = new Sqids();
            assertArrayEquals(sqids.decode(""), [], "Decoding empty string test");
        }

        private function testDecodingInvalidCharacter():void {
            var sqids:Sqids = new Sqids();
            assertArrayEquals(sqids.decode("*"), [], "Decoding invalid character test");
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
