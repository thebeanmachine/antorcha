require 'spec_helper'

describe Identity do


  describe "with private key and organization with certificate" do
    subject { Identity.create :organization => mock_organization, :private_key => example_private_key}

    before(:each) do
      mock_organization.stub \
        :certificate => OpenSSL::X509::Certificate.new(example_certificate)
    end

    it "should create a new instance given valid attributes" do
      should have(:no).errors
    end
  end
  
  describe "with a different private key as the organization" do
    subject { Identity.create :organization => mock_organization, :private_key => other_private_key}

    before(:each) do
      mock_organization.stub \
        :certificate => OpenSSL::X509::Certificate.new(example_certificate)
    end

    it "should have one error on private key" do
      should have(1).error_on(:private_key)
    end
  end

  describe "with a invalid private key" do
    subject { Identity.create :organization => mock_organization, :private_key => 'this is no private key' }

    before(:each) do
      mock_organization.stub \
        :certificate => OpenSSL::X509::Certificate.new(example_certificate)
    end

    it "should have one error on private key" do
      should have(1).error_on(:private_key)
    end
  end
  
  describe "with an organization without an certificate" do
    subject { Identity.create :organization => mock_organization, :private_key => other_private_key}

    before(:each) do
      mock_organization.stub \
        :certificate => nil
    end

    it "should have one error on private key" do
      should have(1).error_on(:private_key)
    end
  end
  
  
  def example_certificate
    certificate = <<-SSL_CERT
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
    SSL_CERT

    certificate.strip.gsub /\n\s+/, "\n"
  end

  def example_private_key
    private_key = <<-SSL_CERT
      -----BEGIN RSA PRIVATE KEY-----
      MIIEpAIBAAKCAQEA0jb32DfuyHyrZcghxzesB/FNpvwzGNlsv37GFND+VLaTdwhZ
      hXUWKe5pLOKKgxgVhMDu/pPdNFPjxbS0frxGvS/k6z18I30LswSzgjwenMdjXWJT
      SPvrTYK9mcJbxF28m+NlXVVv3JB6md1GQzMxwdNk/R72WtbDRasg+aOkySU1Q0sE
      nv5Bs7nC8j+IcJvfeZ5RsAVZSG8OTQHiBL+uyHAMkuZHhsd8foisN0NoQAVPzrfm
      0BOwVDbXK6YLNSlZVS3jTnnd2mYW6n/z7XAbXmY8/Ic8oEzeVqm1uieH1yuphvuP
      LLzj4sGYzkkYlM5BfSEj0PUTmVlFj7HUWBud4QIDAQABAoIBAC3ZW1lHacdEmcWL
      TwK6e8UHtl4TZ7mlwnhJ2D42DyK+547wvUXEcd8XZs0pY/iPyjG4Oug/q+F74pP+
      g9eYjP06cv1z3Z2H6oNTJSvknPCo9F0r0up6N6oiN+RPZeCAaWC+yh7/QXSj9nmU
      r3x8r/+McdxbYnQRn2mUl46bSJeuJn/7UBvDFfklnjHLrwzcji4N9tgo1+hN1rex
      QjZrkoktbvAV7uTuvbu4wx0063907PBqeBY9BLUU1U+sg2Zt6wfDosRcRXIyEG2b
      43JzATYyzE3Sjgmp4Eqlq/12ZB/M3BXvoHbZou0oWvIHP2lV/LrR6r0t9YyB5c7e
      3V3lmbkCgYEA9ezPa40l6V3CGSa/BJQ40Gaqc3+ZvK2Q3ougzPbb9YHTsIIZxnmr
      90zt7J9DOtKD5dIZLwEB/YjkFUlthGsT9bKle6AVt0VKEy/9Ztqu4801S0Phjioe
      xFdyenz57vteASIPKruwzbo1IlfpNcwbOiP75IRcB2rQFQo1nDw9SesCgYEA2tOj
      do55gCB1+UCiEAMB06zB/dC3jBuI/Xk9X0cGalpGrZAe3ur6cnzjO0cxITTnUAeX
      XbX502x7cOMnvm+CShDO7G1lg+tDcLt4ro7lZopZe4rkAmsBixGgos7P7+6E6TZ4
      lOV+Y8Ox0gJsnJqKA7dNeusoNDglNmHMF3/uGGMCgYAW04MxJWnGbmhsszb5stRP
      K6hYjhhz9dxDe8xSGfuynvlKIdlIndSDYMWYt/OiixWpCEZEIaDQqpsZCra6msHA
      hXNstSAu4aSNgV/Q4y1mgY6XzNYrvucaLE+45M7CCtzf2Ax2V/OCNO1noadI0ggY
      7mwb+tkb6yMjQM5XERRTPwKBgQCvgb0CMoVKeT6FmgwhUXgeoNm6S7NbAR6fRaUu
      jJWdqSg0vnm0CryyJG5Pteq2mmrHqj8B3xkvNDvRL69Jsr/Jza9YuukHpCKkAQhq
      4Jsm4eGhD6WONuq28n1m9v6ZjjE1pwWRTntPYr51FJKuC9iT4GmZI5BMSZe3BTse
      wfFhxwKBgQDBRpFtjs1uA30ybCTC+9KcBGSrmIhj4Ir0SwqD+Z6awu6Hso0Gptte
      JwavGASQcd3lZGfOCe57wFyQdNfGKwIZ2IPeLg7ArReYx0eh2AdnDCg2YUp1kwJt
      1OfxmKAzhjiuwU9JHhKimZLaDthXz0kISjNyE8vlWkHDZ4/qLkUW3g==
      -----END RSA PRIVATE KEY-----
    SSL_CERT

    private_key.strip.gsub /\n\s+/, "\n"
  end

  def other_private_key
    private_key = <<-SSL_CERT
      -----BEGIN RSA PRIVATE KEY-----
      MIIEowIBAAKCAQEA0SkO/DgbSzdLB+5OVkSP4KRzbnpQmmSc1ifTOZe1h3GPdhG5
      DbsvAyYeNUobJAP2uQn914SPJfBZOSi957ZIspbWWoOW04hGLpUL6mE5WoSdGnKH
      v3K5wggmbYpMnQHz8GTDUvu6GoK10u/BiSRk7RgoA8qNR36BhjswhZ9uNQ55ZIle
      rr+CNUC0/9ViIyHEJjuB2Dv6AZVoiv6m8i+qjz8tUvdZX6YU/qyeG+vqeu1Ab6nD
      kgrDbHyDC4LPxOJvbIwHHqqgsuhjsflOU1D4G62WggvPngtFFTqGoRxR0MO8+TUb
      DNpUsS1dnPoDtCWdoAUA+dzidYAVAjdXDVVT8wIDAQABAoIBAG5ZSx6mO0Ajm+JD
      R/EbmwzZtkzDG2NZUaVqvXXVJGCg+R9BmnA0IUl4Atf6kPcfYDufmdzqgttxQqF1
      bTuiYBhYnB6E7j4L13scB31QbgHjlT8uzY+j530G7787B9COBzT89FADntv9ug/f
      jivcl6K+692UL5VYmN1IvQDCbFJwrE5oFZl83/KFDqcBFfrVTOOZUVdZJNYlriyd
      z7/2F3kHcC9fFCXm2c5Nu/NQLsXv1VPZbgOExNxsbSvBTVAwGtkSs82yTOOgqGpL
      ibrFzWIzNhlaqqBdq+gVjviY5FUGKofbfA1I4R6GA8JS5voOrgmKXiqiZ8YYavO4
      0LPImwECgYEA6VB82lX+VwreTjhRBisxVgSHX2Tafr7aj5YgU43mKXQ4/cSR3j7E
      WpHtTmCF/DDGYerYIskWhkixdzcqW3ZOZtSBnlxG9GvAv2kBYFrEmZZcHvk/mBpD
      XJ4oXnN8SXMOVeVlVMDSVYEbBAFI8an4WGYkagg72uMz7sMOpGo6F3kCgYEA5X9Y
      L4PbZc8/rtWdu5lSV60W5Y4xxNT0Y4rBNeko/X+58gXuhHNAQ6+fmxExypY3QJRY
      yATgRl8D9Ml1StVotm49uiQTobDXtUNAwUNruzf1APpHvrf2QUUv1s6tcRp2Q8oz
      ffgfWJKy+EmqXh2udFBSu0Zx3PrmQ0yEeXHBr8sCgYB4Rb2W7+2FAV1IBU//VhTA
      uuTuEBdybwBMNJ/FcsjLZdZbOxHW95RQ/BjQ5oErWBlsMJvqkq7B2odhZVa4f2w7
      JiELeZY6ObHK+l5zRVdDtXcXoHVf+2nuPLmitvXDB0TEktSBtES5PyymC+OGcJBN
      QZpT7pqsY6NJ2dOafggkQQKBgQDkIp8LPMxQfKEVr4xI/LT6Kzpjn+KhhAAdI8XF
      Ta5NsTaq/HKKf/cWUfMbNxCEDqeGLvHCg/Zeff10zP8oENUy5IvACjTput3zdpNc
      iyUAyzNmcWX4lO7bG2fe5T1M/b0qzko5ovmmFs6KOtB9FoxhW6eiOvjdbxyPMfVO
      tGKR2QKBgHn4WZnibobiEV+a2BV0E4iQC6YPNAf9EGTtaIxZvNKUU8VMUkeMO3Kp
      BE8Jh7hILJJucerAmUZO+Lm+5hEdsYJy5Y3JsHUYdAv/2UewnPjr69fbrSY/F2n9
      eXkz6ICSCIz5oyGlA9/5f+qOdZtU/wW2N1mEBNxzAAvIvMS7mnpt
      -----END RSA PRIVATE KEY-----
    SSL_CERT

    private_key.strip.gsub /\n\s+/, "\n"
  end

end
