package {
    import org.sqids.Sqids;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.text.TextField;
    import flash.text.TextFormat;

    public class MinLengthTest extends Sprite {
        private var outputField:TextField;

        public function MinLengthTest() {
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
            log("Running MinLengthTest...\n");
            testSimple();
            testIncremental();
            testIncrementalNumbers();
            testMinLengths();
            log("\nAll tests completed.");
        }

        private function testSimple():void {
            var sqids:Sqids = new Sqids({minLength: Sqids.defaultOptions.alphabet.length});
            var numbers:Array = [1, 2, 3];
            var id:String = "86Rf07xd4zBmiJXQG6otHEbew02c3PWsUOLZxADhCpKj7aVFv9I8RquYrNlSTM";

            assertEquals(sqids.encode(numbers), id, "Simple encode test");
            assertArrayEquals(sqids.decode(id), numbers, "Simple decode test");
        }

        private function testIncremental():void {
            var numbers:Array = [1, 2, 3];
            var map:Object = {
                6: "86Rf07",
                7: "86Rf07x",
                8: "86Rf07xd",
                9: "86Rf07xd4",
                10: "86Rf07xd4z",
                11: "86Rf07xd4zB",
                12: "86Rf07xd4zBm",
                13: "86Rf07xd4zBmi"
            };
            map[Sqids.defaultOptions.alphabet.length + 0] = "86Rf07xd4zBmiJXQG6otHEbew02c3PWsUOLZxADhCpKj7aVFv9I8RquYrNlSTM";
            map[Sqids.defaultOptions.alphabet.length + 1] = "86Rf07xd4zBmiJXQG6otHEbew02c3PWsUOLZxADhCpKj7aVFv9I8RquYrNlSTMy";
            map[Sqids.defaultOptions.alphabet.length + 2] = "86Rf07xd4zBmiJXQG6otHEbew02c3PWsUOLZxADhCpKj7aVFv9I8RquYrNlSTMyf";
            map[Sqids.defaultOptions.alphabet.length + 3] = "86Rf07xd4zBmiJXQG6otHEbew02c3PWsUOLZxADhCpKj7aVFv9I8RquYrNlSTMyf1";

            for (var minLength:String in map) {
                var sqids:Sqids = new Sqids({minLength: int(minLength)});
                var id:String = map[minLength];

                assertEquals(sqids.encode(numbers), id, "Incremental encode test for minLength " + minLength);
                assertEquals(sqids.encode(numbers).length, int(minLength), "Incremental length test for minLength " + minLength);
                assertArrayEquals(sqids.decode(id), numbers, "Incremental decode test for minLength " + minLength);
            }
        }

        private function testIncrementalNumbers():void {
            var sqids:Sqids = new Sqids({minLength: Sqids.defaultOptions.alphabet.length});
            var ids:Object = {
                "SvIzsqYMyQwI3GWgJAe17URxX8V924Co0DaTZLtFjHriEn5bPhcSkfmvOslpBu": [0, 0],
                "n3qafPOLKdfHpuNw3M61r95svbeJGk7aAEgYn4WlSjXURmF8IDqZBy0CT2VxQc": [0, 1],
                "tryFJbWcFMiYPg8sASm51uIV93GXTnvRzyfLleh06CpodJD42B7OraKtkQNxUZ": [0, 2],
                "eg6ql0A3XmvPoCzMlB6DraNGcWSIy5VR8iYup2Qk4tjZFKe1hbwfgHdUTsnLqE": [0, 3],
                "rSCFlp0rB2inEljaRdxKt7FkIbODSf8wYgTsZM1HL9JzN35cyoqueUvVWCm4hX": [0, 4],
                "sR8xjC8WQkOwo74PnglH1YFdTI0eaf56RGVSitzbjuZ3shNUXBrqLxEJyAmKv2": [0, 5],
                "uY2MYFqCLpgx5XQcjdtZK286AwWV7IBGEfuS9yTmbJvkzoUPeYRHr4iDs3naN0": [0, 6],
                "74dID7X28VLQhBlnGmjZrec5wTA1fqpWtK4YkaoEIM9SRNiC3gUJH0OFvsPDdy": [0, 7],
                "30WXpesPhgKiEI5RHTY7xbB1GnytJvXOl2p0AcUjdF6waZDo9Qk8VLzMuWrqCS": [0, 8],
                "moxr3HqLAK0GsTND6jowfZz3SUx7cQ8aC54Pl1RbIvFXmEJuBMYVeW9yrdOtin": [0, 9]
            };

            for (var id:String in ids) {
                var numbers:Array = ids[id];
                assertEquals(sqids.encode(numbers), id, "Incremental numbers encode test");
                assertArrayEquals(sqids.decode(id), numbers, "Incremental numbers decode test");
            }
        }

        private function testMinLengths():void {
            var minLengths:Array = [0, 1, 5, 10, Sqids.defaultOptions.alphabet.length];
            var numberSets:Array = [
                [0],
                [0, 0, 0, 0, 0],
                [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
                [100, 200, 300],
                [1000, 2000, 3000],
                [1000000],
                [4294967294]
            ];

            for each (var minLength:int in minLengths) {
                for each (var numbers:Array in numberSets) {
                    var sqids:Sqids = new Sqids({minLength: minLength});
                    var id:String = sqids.encode(numbers);
                    assertTrue(id.length >= minLength, "Min length test for length " + minLength);
                    assertArrayEquals(sqids.decode(id), numbers, "Min length decode test for length " + minLength);
                }
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

        private function assertTrue(condition:Boolean, message:String):void {
            if (!condition) {
                log("FAIL: " + message);
            } else {
                log("PASS: " + message);
            }
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
