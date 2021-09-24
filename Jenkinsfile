pipeline {
  agent { docker { image 'ruby:3.0.1' } }
  stages {
    stage('requirements') {
      steps {
        sh 'gem install bundler -v 2.2.17'
      }
    }
    stage('build') {
      steps {
        sh 'bundle install'
      }
    }
    stage('test') {
      steps {
        sh 'bundle exec rspec'
      }
    }
  }
}
