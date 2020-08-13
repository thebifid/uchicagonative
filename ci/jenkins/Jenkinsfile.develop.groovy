node ("xcode") {
  env.IPA_PATH = 'uchicagonative.ipa'
  env.XCODE_PROJECT = 'Application/uchicagonative.xcodeproj'
  env.XCODE_WORKSPACE = 'Application/uchicagonative.xcworkspace'
  env.XCODE_SCHEME = 'uchicagonative'
  env.XCODE_CONFIG = 'Development_Release'
  env.EXPORT_METHOD = 'enterprise'
  env.CODESIGN_IDENTITY = 'iPhone Distribution'
  env.PROVISION_PROFILE = '8f207aef-afa1-46a8-92b3-a75e651c022b'
  env.PROVISION_PROFILE_PATH = "Artifacts/Provisioning/uChicago_Native_Dev.mobileprovision"
  env.XCODE_INFO_PLIST = "${env.WORKSPACE}/Application/uchicagonative/Commons/Info.plist"
  env.BUNDLE_ID = 'com.enterprise.saritasa.awhvogellab.dev'
  env.TEAM_ID = '97CJYDC5AL'
  env.FIREBASE_ID = '1:447997755530:ios:5eabf54e8cc8faf1012d73'
  env.FIREBASE_GROUP = 'uchicago'
  env.DEVELOPER_DIR = '/Applications/Xcode116.app/Contents/Developer'
  env.CP_HOME_DIR = "${env.WORKSPACE}/.podcache"

  stage('clean') {
      if ("${BUILD_CLEAN}" == "true") {
        cleanWs()
      }
    }
  stage('scm') {
    checkout(scm)
  }
  stage('unlock keychain') {
    withCredentials([string(credentialsId: 'saritasa-default-keycahin-password', variable: 'PASSWORD')]) {
      sh("security unlock-keychain -p ${PASSWORD} xcode.keychain")
      sh("security set-key-partition-list -S apple-tool:,apple:,codesign: -s -k '${PASSWORD}' xcode.keychain")
    }
  }
  stage('pods') {
    dir('Application/') {
      ansiColor('xterm') {
        sh("pod install --repo-update")
      }
    }
  }
  stage('build') {
    ansiColor('xterm') {
      sh("cp -R ci/fastlane ./")
      sh("fastlane ios build")
    }
  }
  stage('deploy:artifacts') {
    archiveArtifacts '*.ipa'
  }
  stage('deploy:firebase') {
    sh("firebase appdistribution:distribute \
      ${IPA_PATH} \
      --app ${FIREBASE_ID} \
      --release-notes \"Build ${BUILD_NUMBER}\" \
      --groups '${FIREBASE_GROUP}'")
  }
}
