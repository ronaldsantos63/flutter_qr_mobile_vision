package com.github.rmtmckenzie.qrmobilevision;

public interface QrReaderCallbacks {
    void qrRead(String data);
    void qrReadTimeout();
    void qrReadError(Throwable error);
}
