module MassTests exposing (suite)

import Expect exposing (FloatingPointTolerance(..))
import Fuzz exposing (floatRange)
import Mass
import Test exposing (Test, describe, fuzz)


suite : Test
suite =
    describe "Mass module"
        [ describe "Converting from lb to kg back to lb"
            [ fuzz (floatRange 1.0 1000.0) "will always be the same" <|
                \randFloat ->
                    let
                        lb =
                            randFloat
                                |> Mass.lb
                    in
                    lb
                        |> Mass.toKg
                        |> Mass.toLb
                        |> Expect.equal lb
            ]
        ]
