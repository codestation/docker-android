FROM gradle:8-jdk17

# https://developer.android.com/studio/#downloads
ENV ANDROID_SDK_URL="https://dl.google.com/android/repository/commandlinetools-linux-10406996_latest.zip" \
    ANDROID_BUILD_TOOLS_VERSION=34.0.0 \
    ANDROID_SDK_ROOT="/opt/android" \
    ANDROID_HOME="/opt/android"

ENV PATH=$PATH:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$ANDROID_SDK_ROOT/platform-tools:$ANDROID_SDK_ROOT/build-tools/$ANDROID_BUILD_TOOLS_VERSION

WORKDIR /opt

# Installs Android SDK
RUN mkdir android && cd android && \
    wget -O tools.zip ${ANDROID_SDK_URL} && \
    unzip tools.zip && rm tools.zip && \
    cd cmdline-tools && \
    mkdir latest && \
    ls | grep -v latest | xargs mv -t latest

RUN mkdir /root/.android && touch /root/.android/repositories.cfg && \
    yes | sdkmanager "platform-tools" "build-tools;${ANDROID_BUILD_TOOLS_VERSION}" && \
    yes | sdkmanager "platforms;android-28" "platforms;android-29" "platforms;android-30" && \
    yes | sdkmanager "platforms;android-31" "platforms;android-32" "platforms;android-33" "platforms;android-34" && \
    yes | sdkmanager "extras;android;m2repository" "extras;google;google_play_services" "extras;google;instantapps" "extras;google;m2repository" &&  \
    yes | sdkmanager "add-ons;addon-google_apis-google-22" "add-ons;addon-google_apis-google-23" "add-ons;addon-google_apis-google-24" "skiaparser;1" "skiaparser;2" "skiaparser;3"

RUN chmod a+x -R $ANDROID_SDK_ROOT && \
    chown -R root:root $ANDROID_SDK_ROOT && \
    rm -rf /opt/android/licenses && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    apt-get autoremove -y && \
    apt-get clean && \
    gradle -v && java -version
