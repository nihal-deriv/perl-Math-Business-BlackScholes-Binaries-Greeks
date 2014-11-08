#!/usr/bin/perl

use lib qw { lib t/lib };
use Test::More tests => 349;
use Test::NoWarnings;

use Math::Business::BlackScholes::Binaries::Greeks::Delta;
use Math::Business::BlackScholes::Binaries::Greeks::Gamma;
use Math::Business::BlackScholes::Binaries::Greeks::Theta;
use Math::Business::BlackScholes::Binaries::Greeks::Vanna;
use Math::Business::BlackScholes::Binaries::Greeks::Vega;
use Math::Business::BlackScholes::Binaries::Greeks::Volga;
use Roundnear;

my $r = 0.002;
my $q = 0.001;

my @test_cases = (
    {
        type     => 'CALL',
        barriers => [1.36],
        t        => 7,
        sigma    => 0.11,
        s        => 1.35,
        delta    => 17.1969,
        gamma    => 397.7032,
        theta    => -4.4077,
        vanna    => -119.8414,
        vega     => 1.5291,
        volga    => -25.0014,
    },
    {
        type     => 'CALL',
        barriers => [1.25],
        t        => 7,
        sigma    => 0.11,
        s        => 1.35,
        delta    => 0.0001,
        gamma    => -0.0141,
        theta    => 0.0022,
        vanna    => 0.0128,
        vega     => -0.0001,
        volga    => -0.0116,
    },
    {
        type     => 'CALL',
        barriers => [1.45],
        t        => 7,
        sigma    => 0.11,
        s        => 1.35,
        delta    => 0.0003,
        gamma    => 0.0714,
        theta    => -0.0008,
        vanna    => 0.0599,
        vega     => 0.0003,
        volga    => 0.0499,
    },
    {
        type     => 'CALL',
        barriers => [1.36],
        t        => 365,
        sigma    => 0.11,
        s        => 1.35,
        delta    => 2.664,
        gamma    => 0.0538,
        theta    => -0.0033,
        vanna    => -24.2104,
        vega     => 0.0108,
        volga    => -3.7927,
    },
    {
        type     => 'CALL',
        barriers => [1.36],
        t        => 7,
        sigma    => 1.00,
        s        => 1.35,
        delta    => 2.1179,
        gamma    => -0.1823,
        theta    => 0.1641,
        vanna    => -2.1221,
        vega     => -0.0064,
        volga    => -0.0421,
    },
    {
        type     => 'CALL',
        barriers => [50],
        t        => 365,
        sigma    => 1.00,
        s        => 1.35,
        delta    => 0.0001,
        gamma    => 0.0001,
        theta    => -0.0001,
        vanna    => 0.0007,
        vega     => 0.0003,
        volga    => 0.0028,
    },
    {
        type     => 'PUT',
        barriers => [1.36],
        t        => 7,
        sigma    => 0.11,
        s        => 1.35,
        delta    => -17.1969,
        gamma    => -397.7032,
        theta    => 4.4097,
        vanna    => 119.8414,
        vega     => -1.5291,
        volga    => 25.0014,
    },
    {
        type     => 'PUT',
        barriers => [1.25],
        t        => 7,
        sigma    => 0.11,
        s        => 1.35,
        delta    => -0.0001,
        gamma    => 0.0141,
        theta    => -0.0002,
        vanna    => -0.0128,
        vega     => 0.0001,
        volga    => 0.0116,
    },
    {
        type     => 'PUT',
        barriers => [1.45],
        t        => 7,
        sigma    => 0.11,
        s        => 1.35,
        delta    => -0.0003,
        gamma    => -0.0714,
        theta    => 0.0028,
        vanna    => -0.0599,
        vega     => -0.0003,
        volga    => -0.0499,
    },
    {
        type     => 'PUT',
        barriers => [1.36],
        t        => 365,
        sigma    => 0.11,
        s        => 1.35,
        delta    => -2.664,
        gamma    => -0.0538,
        theta    => 0.0053,
        vanna    => 24.2104,
        vega     => -0.0108,
        volga    => 3.7927,
    },
    {
        type     => 'PUT',
        barriers => [1.36],
        t        => 7,
        sigma    => 1,
        s        => 1.35,
        delta    => -2.1179,
        gamma    => 0.1823,
        theta    => -0.1621,
        vanna    => 2.1221,
        vega     => 0.0064,
        volga    => 0.0421,
    },
    {
        type     => 'PUT',
        barriers => [50],
        t        => 365,
        sigma    => 1,
        s        => 1.35,
        delta    => -0.0001,
        gamma    => -0.0001,
        theta    => 0.0021,
        vanna    => -0.0007,
        vega     => -0.0003,
        volga    => -0.0028,
    },
    {
        type     => 'VANILLA_CALL',
        barriers => [1.36],
        t        => 7,
        sigma    => 0.11,
        s        => 1.35,
        delta    => 0.3172,
        gamma    => 17.3243,
        theta    => -0.1914,
        vanna    => 1.5897,
        vega     => 0.0666,
        volga    => 0.1413,
    },
    {
        type     => 'VANILLA_CALL',
        barriers => [1.25],
        t        => 7,
        sigma    => 0.11,
        s        => 1.35,
        delta    => 1,
        gamma    => 0.0001,
        theta    => -0.0012,
        vanna    => -0.0001,
        vega     => 0,
        volga    => 0,
    },
    {
        type     => 'VANILLA_CALL',
        barriers => [1.42],
        t        => 7,
        sigma    => 0.11,
        s        => 1.35,
        delta    => 0.0005,
        gamma    => 0.0811,
        theta    => -0.0009,
        vanna    => 0.0504,
        vega     => 0.0003,
        volga    => 0.0312,
    },
    {
        type     => 'VANILLA_CALL',
        barriers => [1.36],
        t        => 365,
        sigma    => 0.11,
        s        => 1.35,
        delta    => 0.4983,
        gamma    => 2.6838,
        theta    => -0.0302,
        vanna    => 0.4094,
        vega     => 0.538,
        volga    => 0.0017,
    },
    {
        type     => 'VANILLA_CALL',
        barriers => [1.35],
        t        => 7,
        sigma    => 1,
        s        => 1.35,
        delta    => 0.5276,
        gamma    => 2.1287,
        theta    => -1.9404,
        vanna    => 0.0275,
        vega     => 0.0744,
        volga    => -0.0004,
    },
    {
        type     => 'VANILLA_CALL',
        barriers => [100],
        t        => 365,
        sigma    => 1,
        s        => 1.35,
        delta    => 0.0001,
        gamma    => 0.0002,
        theta    => -0.0002,
        vanna    => 0.0014,
        vega     => 0.0004,
        volga    => 0.0071,
    },
    {
        type     => 'VANILLA_PUT',
        barriers => [1.36],
        t        => 7,
        sigma    => 0.11,
        s        => 1.35,
        delta    => -0.6828,
        gamma    => 17.3243,
        theta    => -0.1901,
        vanna    => 1.5897,
        vega     => 0.0666,
        volga    => 0.1413,
    },
    {
        type     => 'VANILLA_PUT',
        barriers => [1.25],
        t        => 7,
        sigma    => 0.11,
        s        => 1.35,
        delta    => 0,
        gamma    => 0.0001,
        theta    => 0,
        vanna    => -0.0001,
        vega     => 0,
        volga    => 0,
    },
    {
        type     => 'VANILLA_PUT',
        barriers => [1.42],
        t        => 7,
        sigma    => 0.11,
        s        => 1.35,
        delta    => -0.9995,
        gamma    => 0.0811,
        theta    => 0.0006,
        vanna    => 0.0504,
        vega     => 0.0003,
        volga    => 0.0312,
    },
    {
        type     => 'VANILLA_PUT',
        barriers => [1.36],
        t        => 365,
        sigma    => 0.11,
        s        => 1.35,
        delta    => -0.5007,
        gamma    => 2.6838,
        theta    => -0.0288,
        vanna    => 0.4094,
        vega     => 0.538,
        volga    => 0.0017,
    },
    {
        type     => 'VANILLA_PUT',
        barriers => [1.35],
        t        => 7,
        sigma    => 1,
        s        => 1.35,
        delta    => -0.4723,
        gamma    => 2.1287,
        theta    => -1.939,
        vanna    => 0.0275,
        vega     => 0.0744,
        volga    => -0.0004,
    },
    {
        type     => 'VANILLA_PUT',
        barriers => [100],
        t        => 365,
        sigma    => 1,
        s        => 1.35,
        delta    => -0.9989,
        gamma    => 0.0002,
        theta    => 0.1981,
        vanna    => 0.0014,
        vega     => 0.0004,
        volga    => 0.0071,
    },
    {
        type     => 'ONETOUCH',
        barriers => [1.36],
        t        => 7,
        sigma    => 0.11,
        s        => 1.35,
        delta    => 34.5897,
        gamma    => 806.1289,
        theta    => -8.9339,
        vanna    => -238.0101,
        vega     => 3.1084,
        volga    => -49.8754,
    },
    {
        type     => 'ONETOUCH',
        barriers => [1.25],
        t        => 7,
        sigma    => 0.11,
        s        => 1.35,
        delta    => -0.0001,
        gamma    => 0.0282,
        theta    => -0.0003,
        vanna    => -0.0256,
        vega     => 0.0001,
        volga    => 0.0232,
    },
    {
        type     => 'ONETOUCH',
        barriers => [1.45],
        t        => 7,
        sigma    => 0.11,
        s        => 1.35,
        delta    => 0.0006,
        gamma    => 0.143,
        theta    => -0.0016,
        vanna    => 0.1199,
        vega     => 0.0005,
        volga    => 0.0999,
    },
    {
        type     => 'ONETOUCH',
        barriers => [1.34],
        t        => 7,
        sigma    => 0.11,
        s        => 1.35,
        delta    => -34.3549,
        gamma    => 824.2202,
        theta    => -9.0403,
        vanna    => 240.5381,
        vega     => 3.1594,
        volga    => -50.6114,
    },
    {
        type     => 'ONETOUCH',
        barriers => [1.36],
        t        => 7,
        sigma    => 1,
        s        => 1.35,
        delta    => 4.6076,
        gamma    => 1.2027,
        theta    => -1.1003,
        vanna    => -4.207,
        vega     => 0.0422,
        volga    => -0.0844,
    },
    {
        type     => 'ONETOUCH',
        barriers => [50],
        t        => 365,
        sigma    => 1,
        s        => 1.35,
        delta    => 0.0001,
        gamma    => 0.0003,
        theta    => -0.0003,
        vanna    => 0.0017,
        vega     => 0.0006,
        volga    => 0.0066,
    },
    {
        type     => 'NOTOUCH',
        barriers => [1.36],
        t        => 7,
        sigma    => 0.11,
        s        => 1.35,
        delta    => -34.5882,
        gamma    => -806.0155,
        theta    => 8.9347,
        vanna    => 238.0067,
        vega     => -3.1082,
        volga    => 49.8739,
    },
    {
        type     => 'NOTOUCH',
        barriers => [1.25],
        t        => 7,
        sigma    => 0.11,
        s        => 1.35,
        delta    => 0.0001,
        gamma    => -0.0282,
        theta    => 0.0023,
        vanna    => 0.0256,
        vega     => -0.0001,
        volga    => -0.0232,
    },
    {
        type     => 'NOTOUCH',
        barriers => [1.45],
        t        => 7,
        sigma    => 0.11,
        s        => 1.35,
        delta    => -0.0006,
        gamma    => -0.143,
        theta    => 0.0036,
        vanna    => -0.1199,
        vega     => -0.0005,
        volga    => -0.0999,
    },
    {
        type     => 'NOTOUCH',
        barriers => [1.34],
        t        => 7,
        sigma    => 0.11,
        s        => 1.35,
        delta    => 34.3534,
        gamma    => -824.1062,
        theta    => 9.0411,
        vanna    => -240.5347,
        vega     => -3.1593,
        volga    => 50.6099,
    },
    {
        type     => 'NOTOUCH',
        barriers => [1.36],
        t        => 7,
        sigma    => 1,
        s        => 1.35,
        delta    => -4.6073,
        gamma    => -1.2006,
        theta    => 1.1004,
        vanna    => 4.2067,
        vega     => -0.0422,
        volga    => 0.0844,
    },
    {
        type     => 'NOTOUCH',
        barriers => [50],
        t        => 365,
        sigma    => 1,
        s        => 1.35,
        delta    => -0.0001,
        gamma    => -0.0003,
        theta    => 0.0023,
        vanna    => -0.0017,
        vega     => -0.0006,
        volga    => -0.0066,
    },
    {
        type     => 'EXPIRYRANGE',
        barriers => [ 1.36, 1.34 ],
        t        => 7,
        sigma    => 0.11,
        s        => 1.35,
        delta    => 0.0764,
        gamma    => -815.1082,
        theta    => 8.9881,
        vanna    => 0.4024,
        vega     => -3.1339,
        volga    => 50.2401,
    },
    {
        type     => 'EXPIRYRANGE',
        barriers => [ 2.5, 1.34 ],
        t        => 7,
        sigma    => 0.11,
        s        => 1.35,
        delta    => 17.2733,
        gamma    => -417.405,
        theta    => 4.5804,
        vanna    => -119.4391,
        vega     => -1.6048,
        volga    => 25.2386,
    },
    {
        type     => 'EXPIRYRANGE',
        barriers => [ 1.36, 1.34 ],
        t        => 7,
        sigma    => 1,
        s        => 1.35,
        delta    => 0.0157,
        gamma    => -1.2222,
        theta    => 1.1138,
        vanna    => -0.0155,
        vega     => -0.0427,
        volga    => 0.0851,
    },
    {
        type     => 'EXPIRYRANGE',
        barriers => [ 1.36, 1.34 ],
        t        => 365,
        sigma    => 0.11,
        s        => 1.35,
        delta    => 0.0164,
        gamma    => -2.4307,
        theta    => 0.0269,
        vanna    => -0.088,
        vega     => -0.4873,
        volga    => 8.8255,
    },
    {
        type     => 'EXPIRYRANGE',
        barriers => [ 50, 0.05 ],
        t        => 365,
        sigma    => 1,
        s        => 1.35,
        delta    => 0.0058,
        gamma    => -0.0167,
        theta    => 0.0172,
        vanna    => 0.056,
        vega     => -0.0305,
        volga    => -0.2716,
    },
    {
        type     => 'EXPIRYMISS',
        barriers => [ 1.36, 1.34 ],
        t        => 7,
        sigma    => 0.11,
        s        => 1.35,
        delta    => -0.0764,
        gamma    => 815.1082,
        theta    => -8.9861,
        vanna    => -0.4024,
        vega     => 3.1339,
        volga    => -50.2401,
    },
    {
        type     => 'EXPIRYMISS',
        barriers => [ 2.5, 1.34 ],
        t        => 7,
        sigma    => 0.11,
        s        => 1.35,
        delta    => -17.2733,
        gamma    => 417.405,
        theta    => -4.5784,
        vanna    => 119.4391,
        vega     => 1.6048,
        volga    => -25.2386,
    },
    {
        type     => 'EXPIRYMISS',
        barriers => [ 1.36, 1.34 ],
        t        => 7,
        sigma    => 1,
        s        => 1.35,
        delta    => -0.0157,
        gamma    => 1.2222,
        theta    => -1.1118,
        vanna    => 0.0155,
        vega     => 0.0427,
        volga    => -0.0851,
    },
    {
        type     => 'EXPIRYMISS',
        barriers => [ 1.36, 1.34 ],
        t        => 365,
        sigma    => 0.11,
        s        => 1.35,
        delta    => -0.0164,
        gamma    => 2.4307,
        theta    => -0.0249,
        vanna    => 0.088,
        vega     => 0.4873,
        volga    => -8.8255,
    },
    {
        type     => 'EXPIRYMISS',
        barriers => [ 50, 0.05 ],
        t        => 365,
        sigma    => 1,
        s        => 1.35,
        delta    => -0.0058,
        gamma    => 0.0167,
        theta    => -0.0152,
        vanna    => -0.056,
        vega     => 0.0305,
        volga    => 0.2716,
    },
    {
        type     => 'RANGE',
        barriers => [ 1.36, 1.34 ],
        t        => 7,
        sigma    => 0.11,
        s        => 1.35,
        delta    => -0.0042,
        gamma    => -170.3061,
        theta    => 1.8778,
        vanna    => 0.4036,
        vega     => -0.6548,
        volga    => 56.1613,
    },
    {
        type     => 'RANGE',
        barriers => [ 2.5, 1.34 ],
        t        => 7,
        sigma    => 0.11,
        s        => 1.35,
        delta    => 34.3536,
        gamma    => -824.0811,
        theta    => 9.0408,
        vanna    => -240.5574,
        vega     => -3.1592,
        volga    => 50.5904,
    },
    {
        type     => 'RANGE',
        barriers => [ 1.36, 1.34 ],
        t        => 7,
        sigma    => 0.05,
        s        => 1.35,
        delta    => -0.3656,
        gamma    => -10683.449,
        theta    => 24.3396,
        vanna    => 20.7648,
        vega     => -18.6707,
        volga    => 428.1438,
    },
    {
        type     => 'RANGE',
        barriers => [ 1.4, 1.3 ],
        t        => 365,
        sigma    => 0.11,
        s        => 1.35,
        delta    => 0,
        gamma    => -0.0237,
        theta    => 0.0003,
        vanna    => 0.0029,
        vega     => -0.0048,
        volga    => 0.8981,
    },
    {
        type     => 'RANGE',
        barriers => [ 50, 0.05 ],
        t        => 365,
        sigma    => 1,
        s        => 1.35,
        delta    => 0.0102,
        gamma    => -0.0292,
        theta    => 0.0286,
        vanna    => 0.0953,
        vega     => -0.0532,
        volga    => -0.4597,
    },
    {
        type     => 'RANGE',
        barriers => [ 1.35, 1.34 ],
        t        => 7,
        sigma    => 0.11,
        s        => 1.35,
        delta    => 0,
        gamma    => 0,
        theta    => 0.002,
        vanna    => 0.0002,
        vega     => 0,
        volga    => 0,
    },
    {
        type     => 'UPORDOWN',
        barriers => [ 1.36, 1.34 ],
        t        => 7,
        sigma    => 0.11,
        s        => 1.35,
        delta    => 0.0042,
        gamma    => 170.4863,
        theta    => -1.8778,
        vanna    => -0.4037,
        vega     => 0.6549,
        volga    => -56.1652,
    },
    {
        type     => 'UPORDOWN',
        barriers => [ 2.5, 1.34 ],
        t        => 7,
        sigma    => 0.11,
        s        => 1.35,
        delta    => -34.3551,
        gamma    => 824.1951,
        theta    => -9.04,
        vanna    => 240.5608,
        vega     => 3.1593,
        volga    => -50.592,
    },
    {
        type     => 'UPORDOWN',
        barriers => [ 1.36, 1.34 ],
        t        => 7,
        sigma    => 0.05,
        s        => 1.35,
        delta    => 0.3656,
        gamma    => 10683.9465,
        theta    => -24.3387,
        vanna    => -20.7651,
        vega     => 18.6711,
        volga    => -428.1436,
    },
    {
        type     => 'UPORDOWN',
        barriers => [ 1.4, 1.3 ],
        t        => 365,
        sigma    => 0.11,
        s        => 1.35,
        delta    => 0.0001,
        gamma    => 0.2051,
        theta    => -0.0003,
        vanna    => -0.0053,
        vega     => 0.0089,
        volga    => -1.0103,
    },
    {
        type     => 'UPORDOWN',
        barriers => [ 50, 0.05 ],
        t        => 365,
        sigma    => 1,
        s        => 1.35,
        delta    => -0.0102,
        gamma    => 0.0292,
        theta    => -0.0266,
        vanna    => -0.0954,
        vega     => 0.0532,
        volga    => 0.4598,
    },
    {
        type     => 'UPORDOWN',
        barriers => [ 1.35, 1.34 ],
        t        => 7,
        sigma    => 0.11,
        s        => 1.35,
        delta    => 0.0009,
        gamma    => 0.1813,
        theta    => 0,
        vanna    => -0.0167,
        vega     => 0,
        volga    => 0,
    },
);

foreach my $case (@test_cases) {
    my $bet_type = $case->{type};
    foreach my $greek (qw(delta gamma theta vanna vega volga)) {
        my $formula_name =
            'Math::Business::BlackScholes::Binaries::Greeks::'
          . ucfirst($greek) . '::'
          . lc($bet_type);
        my $computed_value = &$formula_name(
            $case->{s},
            @{ $case->{barriers} },
            $case->{t} / 365,
            $r, $r - $q, $case->{sigma}
          ),
          my $test_value = $case->{$greek};
        is(
            roundnear( 1e-4, $computed_value ),
            $test_value,
            $case->{t} . 'D '
              . $bet_type
              . ' barrier:['
              . $case->{barriers}[0] . ','
              . $case->{barriers}[1] . '] '
              . $greek
        );
    }
}
