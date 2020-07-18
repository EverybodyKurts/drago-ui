module Util.FloatTests exposing (suite)

import Expect exposing (FloatingPointTolerance(..))
import Test exposing (Test, describe, test)
import Util.Float


suite : Test
suite =
    describe "Util.Float module"
        [ describe "Util.Float.round"
            [ test "rounds 1.23456 to 1.23" <|
                \_ ->
                    1.23456
                        |> Util.Float.round 2
                        |> Expect.within (Absolute 0.001) 1.23
            , test "rounds 1.235 to 1.24" <|
                \_ ->
                    1.235
                        |> Util.Float.round 2
                        |> Expect.within (Absolute 0.001) 1.24
            ]
        ]
