pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                bat 'build.cmd'
            }
        }
        stage('Package') {
            steps {
                bat 'package.cmd'
            }
        }
    }
    post {
        always {
            archiveArtifacts artifacts: 'Github*.zip'
        }
        success {
            ftpPublisher alwaysPublishFromMaster: false, masterNodeName: '', paramPublish: null,
            continueOnError: false,
            failOnError: false,
            publishers: [
                [
                    configName: 'WrightPlan Releases',
                    transfers: [
                        [
                            asciiMode: false,
                            cleanRemote: false,
                            remoteDirectory: 'WrightPlanGithub',
                            removePrefix: '',
                            sourceFiles: 'Github*.zip'
                        ]
                    ],
                    verbose: true
                ]
            ]
        }
    }
}