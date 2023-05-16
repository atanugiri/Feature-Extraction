% Author: Atanu Giri
% Date: 12/12/2022
% This function chooses the maze and feeder in which the trial is taking
% place. It returns the edges of the central zone according to the input
% zone size.

function [xEdge,yEdge,xEdgeOfFeeder,yEdgeOfFeeder] = centralZoneEdges(mazeIndex,zoneSize,feeder)
% mazeIndex = 2; feeder = 4; zoneSize = 0.5;
feederSize = 0.3;
switch mazeIndex
    case 1
        % Maze2 a.k.a 1st quadrant
        xMid = 0.5; yMid = 0.5;
        xEdge = [(xMid - zoneSize/2) (xMid + zoneSize/2)];
        yEdge = [(yMid - zoneSize/2) (yMid + zoneSize/2)];
        xEdgeOfZones = {[0.75 0.75+feederSize],[-0.05 -0.05+feederSize],[-0.05 -0.05+feederSize],[0.75 0.75+feederSize]};
        yEdgeOfZones = {[-0.05 -0.05+feederSize],[-0.05 -0.05+feederSize],[0.75 0.75+feederSize],[0.75 0.75+feederSize]};
        xEdgeOfFeeder = xEdgeOfZones{feeder}; yEdgeOfFeeder = yEdgeOfZones{feeder};
    case 2
        % Maze1 a.k.a 2nd quadrant
        xMid = -0.5; yMid = 0.5;
        xEdge = [(xMid - zoneSize/2) (xMid + zoneSize/2)];
        yEdge = [(yMid - zoneSize/2) (yMid + zoneSize/2)];
        xEdgeOfZones = {[-1.05 -1.05+feederSize],[-1.05 -1.05+feederSize],[-0.25 -0.25+feederSize],[-0.25 -0.25+feederSize]};
        yEdgeOfZones = {[0.75 0.75+feederSize],[-0.05 -0.05+feederSize],[-0.05 -0.05+feederSize],[0.75 0.75+feederSize]};
        xEdgeOfFeeder = xEdgeOfZones{feeder}; yEdgeOfFeeder = yEdgeOfZones{feeder};
    case 3
        % Maze3 a.k.a 3rd quadrant
        xMid = -0.5; yMid = -0.5;
        xEdge = [(xMid - zoneSize/2) (xMid + zoneSize/2)];
        yEdge = [(yMid - zoneSize/2) (yMid + zoneSize/2)];
        xEdgeOfZones = {[-0.25 -0.25+feederSize],[-0.25 -0.25+feederSize],[-1.05 -1.05+feederSize],[-1.05 -1.05+feederSize]};
        yEdgeOfZones = {[-1.05 -1.05+feederSize],[-0.25 -0.25+feederSize],[-0.25 -0.25+feederSize],[-1.05 -1.05+feederSize]};
        xEdgeOfFeeder = xEdgeOfZones{feeder}; yEdgeOfFeeder = yEdgeOfZones{feeder};
    case 4
        % Maze4 a.k.a 4th quadrant
        xMid = 0.5; yMid = -0.5;
        xEdge = [(xMid - zoneSize/2) (xMid + zoneSize/2)];
        yEdge = [(yMid - zoneSize/2) (yMid + zoneSize/2)];
        xEdgeOfZones = {[-0.05 -0.05+feederSize],[0.75 0.75+feederSize],[0.75 0.75+feederSize],[-0.05 -0.05+feederSize]};
        yEdgeOfZones = {[-0.25 -0.25+feederSize],[-0.25 -0.25+feederSize],[-1.05 -1.05+feederSize],[-1.05 -1.05+feederSize]};
        xEdgeOfFeeder = xEdgeOfZones{feeder}; yEdgeOfFeeder = yEdgeOfZones{feeder};
    otherwise
        warning('Unexpected maze number.')
end
end