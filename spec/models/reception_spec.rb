require 'spec_helper'

describe Reception do

  describe "comparing x509 certificates" do
    describe "by subject" do
      it "using the compare operator" do
        result = certificate.subject <=> certificate.subject
        result.should == 0
      end

      it "using the compare operator on two different certificates" do
        result = certificate.subject <=> other_certificate.subject
        result.should_not == 0
      end

      it "eql? works to but is not documented" do
        result = certificate.subject.eql? certificate.subject
        result.should be_true
      end
    end

    describe "by public key" do
      it "should be able to compare public keys" do
        result = certificate.public_key.to_s.eql? certificate.public_key.to_s
        result.should be_true
      end

      it "should be able to compare public keys and return false if public keys don't match" do
        result = certificate.public_key.to_s.eql? other_certificate.public_key.to_s
        result.should_not be_true
      end
    end

    describe "should be comparable on subject and public key" do
      it "works if two certificates are the same" do
        certificate.should == certificate
      end

      it "negates if two certificates are different" do
        certificate.should_not == other_certificate
      end
    end
    
  end
  
  def certificate
    OpenSSL::X509::Certificate.new <<-CERT.strip.gsub /\n\s+/, "\n"
      -----BEGIN CERTIFICATE-----
      MIIEtzCCA5+gAwIBAgIJAKIBAaGF7ZwtMA0GCSqGSIb3DQEBBQUAMIGYMQswCQYD
      VQQGEwJOTDETMBEGA1UECBMKT3Zlcmlqc3NlbDERMA8GA1UEBxMIRW5zY2hlZGUx
      GDAWBgNVBAoTD0V4YW1wbGUgQ29tcGFueTEQMA4GA1UECxMHRXhhbXBsZTEUMBIG
      A1UEAxMLZXhhbXBsZS5jb20xHzAdBgkqhkiG9w0BCQEWEHRlc3RAZXhhbXBsZS5j
      b20wHhcNMTAwOTEzMDkxNzMxWhcNMjAwOTEwMDkxNzMxWjCBmDELMAkGA1UEBhMC
      TkwxEzARBgNVBAgTCk92ZXJpanNzZWwxETAPBgNVBAcTCEVuc2NoZWRlMRgwFgYD
      VQQKEw9FeGFtcGxlIENvbXBhbnkxEDAOBgNVBAsTB0V4YW1wbGUxFDASBgNVBAMT
      C2V4YW1wbGUuY29tMR8wHQYJKoZIhvcNAQkBFhB0ZXN0QGV4YW1wbGUuY29tMIIB
      IjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA0jb32DfuyHyrZcghxzesB/FN
      pvwzGNlsv37GFND+VLaTdwhZhXUWKe5pLOKKgxgVhMDu/pPdNFPjxbS0frxGvS/k
      6z18I30LswSzgjwenMdjXWJTSPvrTYK9mcJbxF28m+NlXVVv3JB6md1GQzMxwdNk
      /R72WtbDRasg+aOkySU1Q0sEnv5Bs7nC8j+IcJvfeZ5RsAVZSG8OTQHiBL+uyHAM
      kuZHhsd8foisN0NoQAVPzrfm0BOwVDbXK6YLNSlZVS3jTnnd2mYW6n/z7XAbXmY8
      /Ic8oEzeVqm1uieH1yuphvuPLLzj4sGYzkkYlM5BfSEj0PUTmVlFj7HUWBud4QID
      AQABo4IBADCB/TAdBgNVHQ4EFgQUTripayVscuwF1qU/GAoqODsg/nYwgc0GA1Ud
      IwSBxTCBwoAUTripayVscuwF1qU/GAoqODsg/nahgZ6kgZswgZgxCzAJBgNVBAYT
      Ak5MMRMwEQYDVQQIEwpPdmVyaWpzc2VsMREwDwYDVQQHEwhFbnNjaGVkZTEYMBYG
      A1UEChMPRXhhbXBsZSBDb21wYW55MRAwDgYDVQQLEwdFeGFtcGxlMRQwEgYDVQQD
      EwtleGFtcGxlLmNvbTEfMB0GCSqGSIb3DQEJARYQdGVzdEBleGFtcGxlLmNvbYIJ
      AKIBAaGF7ZwtMAwGA1UdEwQFMAMBAf8wDQYJKoZIhvcNAQEFBQADggEBAMR0uipi
      Ia+N3LB3GEKTwuAjYE+AjZq5Tx3H8pObV/i4fv/Qg/0MjokqmxAoK4Ko7jjpCjoM
      looUGPqd0lmq2NjgYMhw2MILxg4H5hzb0GMO6uZKGMlUnncQGU5dqIv9YYtC3K2C
      FMXeZb6X3U5qCJIHdU2eT9XIm/4CE3UPhngyPriWFU9ReVcUphG8RMUf+Gr3aBOU
      O35GhuS2SVwXDUX0MQiJMqLzYtrxtXkT7ldtMVdX0fj37GNYIoBuSgfIyhu7O7G1
      5+XmXQJeCX+2TlNvJIqvf1hI33eHPxQv5KaBGwHEcaXJDQ4paTYCckSnESZjDc3u
      CvqlnOQjbBl66lU=
      -----END CERTIFICATE-----
    CERT
  end
  
  def other_certificate
    OpenSSL::X509::Certificate.new <<-CERT.strip.gsub /\n\s+/, "\n"
      -----BEGIN CERTIFICATE-----
      MIIDXDCCAkQCCQCRchMTtxIoWDANBgkqhkiG9w0BAQUFADCBuDELMAkGA1UEBhMC
      TkwxEzARBgNVBAgTCk92ZXJpanNzZWwxETAPBgNVBAcTCEVuc2NoZWRlMR4wHAYD
      VQQKExVUaGUgQmVhbiBNYWNoaW5lIEIuVi4xHjAcBgNVBAsTFUNlcnRpZmljYXRl
      IEF1dGhvcml0eTEaMBgGA1UEAxMRdGhlYmVhbm1hY2hpbmUubmwxJTAjBgkqhkiG
      9w0BCQEWFmluZm9AdGhlYmVhbm1hY2hpbmUubmwwHhcNMTAwOTE0MDgzNjQwWhcN
      MjAwOTExMDgzNjQwWjCBqjELMAkGA1UEBhMCTkwxEzARBgNVBAgTCk92ZXJpanNz
      ZWwxETAPBgNVBAcTCEVuc2NoZWRlMR4wHAYDVQQKExVUaGUgQmVhbiBNYWNoaW5l
      IEIuVi4xEjAQBgNVBAsTCUpldWdkem9yZzEYMBYGA1UEAxMPamV1Z2R6b3JnLmxv
      Y2FsMSUwIwYJKoZIhvcNAQkBFhZpbmZvQHRoZWJlYW5tYWNoaW5lLm5sMIGfMA0G
      CSqGSIb3DQEBAQUAA4GNADCBiQKBgQC9rldWJQ9V+nFzkcRywShb24vwcTyzBIg7
      3Y8Qd+REWQq944CIzMmCStxnRRY++6L3txSMVp7YA9TZNlH7a1ZQtZc7Kq3+g3Me
      Dq/6bNRweY4iVIFFygFFv1AhRgCmVtEyeF75AvJccZNBY07jOZUwnF9qDWM1Ueh5
      LCN9Ju4LbQIDAQABMA0GCSqGSIb3DQEBBQUAA4IBAQBni9e2kHSh2Y9oeKGIcih2
      dXRJlIayHvTW/oGhy6s8zSUE3WxfCuFczI/lxTMntnN/DgOUgaXMvJhyB09tfEXD
      cvgX3lq3UCZjacEGZcv5iBENLQimN28atlebvgP5jwHmkBajdrYXJXCtS6ZNQv6C
      7B82gkMlD3l3Q+yTBEZg2fwbNAUu/4K3Gkp0f5dw3rnLdsDlameLHg5EAwKWej9y
      hSf3n5U2Zp7nZGOBwzSAfPVowX+c+tkXf+kJUOVoQwoKNU9BsDm4TTAqdrdIntWG
      c/YXyjpZDDxxgPRvqTgn/YxJBejiCHKMYSmSSwXzdtMQi2CdFXwmJU0NMhYo9YQe
      -----END CERTIFICATE-----
    CERT
  end
  
end
