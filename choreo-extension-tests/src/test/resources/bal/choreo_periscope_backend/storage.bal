// Copyright (c) 2021 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

type ObservabilityGroup record {|
    string id;
    string projectSecret;
    ObservabilityVersion[] versions;
|};

type ObservabilityVersion record {|
    string id;
    string astHash;
|};

ObservabilityGroup[] obsGroups = [];

type VersionInfo record {|
    string obsId;
    string obsVersion;
    boolean isNewSyntaxTree;
|};

function getVersionInformation(string projectSecret, string astHash) returns VersionInfo {
    ObservabilityGroup? pickedObsGroup = ();
    foreach ObservabilityGroup obsGroup in obsGroups {
        if (obsGroup.projectSecret == projectSecret) {
            pickedObsGroup = obsGroup;
        }
    }
    ObservabilityGroup obsGroup;
    if (pickedObsGroup is ()) {
        ObservabilityGroup newObsGroup = {
            id: generateId(projectSecret),
            projectSecret: projectSecret,
            versions: []
        };
        obsGroups.push(newObsGroup);
        obsGroup = newObsGroup;
    } else {
        obsGroup = pickedObsGroup;
    }

    ObservabilityVersion? pickedVersion = ();
    foreach ObservabilityVersion obsVersion in obsGroup.versions {
        if (obsVersion.astHash == astHash) {
            pickedVersion = obsVersion;
        }
    }
    ObservabilityVersion obsVersion;
    if (pickedVersion is ()) {
        ObservabilityVersion newObsVersion = {
            id: generateId(projectSecret),
            astHash: astHash
        };
        obsGroup.versions.push(newObsVersion);
        obsVersion = newObsVersion;
    } else {
        obsVersion = pickedVersion;
    }
    return {
        obsId: obsGroup.id,
        obsVersion: obsVersion.id,
        isNewSyntaxTree: (pickedVersion is ())
    };
}

int idCounter = 0;

function generateId(string projectSecret) returns string {
    idCounter += 1;
    return projectSecret + "-" + idCounter.toString();
}
