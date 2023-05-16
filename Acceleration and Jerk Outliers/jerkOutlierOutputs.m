function jerkOutlierOutputs
loadfile = load('input_data.mat');
jerkOutlier1to50000 = load('jerkOutlier1to50000.mat');
jerkOutlier50001to54154 = load('jerkOutlier50001to54154.mat');
jerkOutlier54155to90000 = load('jerkOutlier54155to90000.mat');
jerkOutlier90001to100000 = load('jerkOutlier90001to100000.mat');
jerkOutlier100001to111136 = load('jerkOutlier100001to111136.mat');
jerkOutlier102844to111136 = load('jerkOutlier102844to111136.mat');

Row = [jerkOutlier1to50000.Row;jerkOutlier50001to54154.Row;jerkOutlier54155to90000.Row; ...
    jerkOutlier90001to100000.Row;jerkOutlier100001to111136.Row(1:2843);jerkOutlier102844to111136.Row];
accOutlierMethod1 = [jerkOutlier1to50000.accOutlierMethod1;jerkOutlier50001to54154.accOutlierMethod1;jerkOutlier54155to90000.accOutlierMethod1; ...
    jerkOutlier90001to100000.accOutlierMethod1;jerkOutlier100001to111136.accOutlierMethod1(1:2843);jerkOutlier102844to111136.accOutlierMethod1];
accOutlierMedian = [jerkOutlier1to50000.accOutlierMedian;jerkOutlier50001to54154.accOutlierMedian;jerkOutlier54155to90000.accOutlierMedian; ...
    jerkOutlier90001to100000.accOutlierMedian;jerkOutlier100001to111136.accOutlierMedian(1:2843);jerkOutlier102844to111136.accOutlierMedian];
accOutlierMoveMedian = [jerkOutlier1to50000.accOutlierMoveMedian;jerkOutlier50001to54154.accOutlierMoveMedian;jerkOutlier54155to90000.accOutlierMoveMedian; ...
    jerkOutlier90001to100000.accOutlierMoveMedian;jerkOutlier100001to111136.accOutlierMoveMedian(1:2843);jerkOutlier102844to111136.accOutlierMoveMedian];
accOutlierMean = [jerkOutlier1to50000.accOutlierMean;jerkOutlier50001to54154.accOutlierMean;jerkOutlier54155to90000.accOutlierMean; ...
    jerkOutlier90001to100000.accOutlierMean;jerkOutlier100001to111136.accOutlierMean(1:2843);jerkOutlier102844to111136.accOutlierMean];
accOutlierQuartiles = [jerkOutlier1to50000.accOutlierQuartiles;jerkOutlier50001to54154.accOutlierQuartiles;jerkOutlier54155to90000.accOutlierQuartiles; ...
    jerkOutlier90001to100000.accOutlierQuartiles;jerkOutlier100001to111136.accOutlierQuartiles(1:2843);jerkOutlier102844to111136.accOutlierQuartiles];
accOutlierGrubbs = [jerkOutlier1to50000.accOutlierGrubbs;jerkOutlier50001to54154.accOutlierGrubbs;jerkOutlier54155to90000.accOutlierGrubbs; ...
    jerkOutlier90001to100000.accOutlierGrubbs;jerkOutlier100001to111136.accOutlierGrubbs(1:2843);jerkOutlier102844to111136.accOutlierGrubbs];
accOutlierGesd = [jerkOutlier1to50000.accOutlierGesd;jerkOutlier50001to54154.accOutlierGesd;jerkOutlier54155to90000.accOutlierGesd; ...
    jerkOutlier90001to100000.accOutlierGesd;jerkOutlier100001to111136.accOutlierGesd(1:2843);jerkOutlier102844to111136.accOutlierGesd];
accOutlierThreshold = [jerkOutlier1to50000.accOutlierThreshold;jerkOutlier50001to54154.accOutlierThreshold;jerkOutlier54155to90000.accOutlierThreshold; ...
    jerkOutlier90001to100000.accOutlierThreshold;jerkOutlier100001to111136.accOutlierThreshold(1:2843);jerkOutlier102844to111136.accOutlierThreshold];

jerkOutlierMethod1 = [jerkOutlier1to50000.jerkOutlierMethod1;jerkOutlier50001to54154.jerkOutlierMethod1;jerkOutlier54155to90000.jerkOutlierMethod1; ...
    jerkOutlier90001to100000.jerkOutlierMethod1;jerkOutlier100001to111136.jerkOutlierMethod1(1:2843);jerkOutlier102844to111136.jerkOutlierMethod1];
jerkOutlierMedian = [jerkOutlier1to50000.jerkOutlierMedian;jerkOutlier50001to54154.jerkOutlierMedian;jerkOutlier54155to90000.jerkOutlierMedian; ...
    jerkOutlier90001to100000.jerkOutlierMedian;jerkOutlier100001to111136.jerkOutlierMedian(1:2843);jerkOutlier102844to111136.jerkOutlierMedian];
jerkOutlierMoveMedian = [jerkOutlier1to50000.jerkOutlierMoveMedian;jerkOutlier50001to54154.jerkOutlierMoveMedian;jerkOutlier54155to90000.jerkOutlierMoveMedian; ...
    jerkOutlier90001to100000.jerkOutlierMoveMedian;jerkOutlier100001to111136.jerkOutlierMoveMedian(1:2843);jerkOutlier102844to111136.jerkOutlierMoveMedian];
jerkOutlierMean = [jerkOutlier1to50000.jerkOutlierMean;jerkOutlier50001to54154.jerkOutlierMean;jerkOutlier54155to90000.jerkOutlierMean; ...
    jerkOutlier90001to100000.jerkOutlierMean;jerkOutlier100001to111136.jerkOutlierMean(1:2843);jerkOutlier102844to111136.jerkOutlierMean];
jerkOutlierQuartiles = [jerkOutlier1to50000.jerkOutlierQuartiles;jerkOutlier50001to54154.jerkOutlierQuartiles;jerkOutlier54155to90000.jerkOutlierQuartiles; ...
    jerkOutlier90001to100000.jerkOutlierQuartiles;jerkOutlier100001to111136.jerkOutlierQuartiles(1:2843);jerkOutlier102844to111136.jerkOutlierQuartiles];
jerkOutlierGrubbs = [jerkOutlier1to50000.jerkOutlierGrubbs;jerkOutlier50001to54154.jerkOutlierGrubbs;jerkOutlier54155to90000.jerkOutlierGrubbs; ...
    jerkOutlier90001to100000.jerkOutlierGrubbs;jerkOutlier100001to111136.jerkOutlierGrubbs(1:2843);jerkOutlier102844to111136.jerkOutlierGrubbs];
jerkOutlierGesd = [jerkOutlier1to50000.jerkOutlierGesd;jerkOutlier50001to54154.jerkOutlierGesd;jerkOutlier54155to90000.jerkOutlierGesd; ...
    jerkOutlier90001to100000.jerkOutlierGesd;jerkOutlier100001to111136.jerkOutlierGesd(1:2843);jerkOutlier102844to111136.jerkOutlierGesd];
jerkOutlierThreshold = [jerkOutlier1to50000.jerkOutlierThreshold;jerkOutlier50001to54154.jerkOutlierThreshold;jerkOutlier54155to90000.jerkOutlierThreshold; ...
    jerkOutlier90001to100000.jerkOutlierThreshold;jerkOutlier100001to111136.jerkOutlierThreshold(1:2843);jerkOutlier102844to111136.jerkOutlierThreshold];


jerkOutlierOutputs = loadfile.input_data;
jerkOutlierOutputs.row = Row;
jerkOutlierOutputs.accOutlierMethod1 = accOutlierMethod1;
jerkOutlierOutputs.accOutlierMedian = accOutlierMedian;
jerkOutlierOutputs.accOutlierMoveMedian = accOutlierMoveMedian;
jerkOutlierOutputs.accOutlierMean = accOutlierMean;
jerkOutlierOutputs.accOutlierQuartiles = accOutlierQuartiles;
jerkOutlierOutputs.accOutlierGrubbs = accOutlierGrubbs;
jerkOutlierOutputs.accOutlierGesd = accOutlierGesd;
jerkOutlierOutputs.accOutlierThreshold = accOutlierThreshold;

jerkOutlierOutputs.jerkOutlierMethod1 = jerkOutlierMethod1;
jerkOutlierOutputs.jerkOutlierMedian = jerkOutlierMedian;
jerkOutlierOutputs.jerkOutlierMoveMedian = jerkOutlierMoveMedian;
jerkOutlierOutputs.jerkOutlierMean = jerkOutlierMean;
jerkOutlierOutputs.jerkOutlierQuartiles = jerkOutlierQuartiles;
jerkOutlierOutputs.jerkOutlierGrubbs = jerkOutlierGrubbs;
jerkOutlierOutputs.jerkOutlierGesd = jerkOutlierGesd;
jerkOutlierOutputs.jerkOutlierThreshold = jerkOutlierThreshold;

save('jerkOutlierOutputs1to111136','jerkOutlierOutputs');
end