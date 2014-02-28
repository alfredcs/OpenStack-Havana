#
# Cookbook Name:: openssl
# Library:: keypair
# Author:: AJ Christensen <aj@junglist.gen.nz>
#
# Copyright 2011, AJ Christensen <aj@junglist.gen.nz>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
module Opscode
  module OpenSSL
    module Keypair
      def create_self_signed_cert(bits, cn, comment)
        rsa = OpenSSL::PKey::RSA.new(bits)
        cert = OpenSSL::X509::Certificate.new
        cert.version = 3
        cert.serial = 0
        name = OpenSSL::X509::Name.new(cn)
        cert.subject = name
        cert.issuer = name
        cert.not_before = Time.now
        cert.public_key = rsa.public_key

        ef = OpenSSL::X509::ExtensionFactory.new(nil,cert)
        ef.issuer_certificate = cert
        cert.extensions = [
                           ef.create_extension("basicConstraints","CA:FALSE"),
                           ef.create_extension("keyUsage", "keyEncipherment"),
                           ef.create_extension("subjectKeyIdentifier", "hash"),
                           ef.create_extension("extendedKeyUsage", "serverAuth"),
                           ef.create_extension("nsComment", comment),
                          ]
        aki = ef.create_extension("authorityKeyIdentifier",
                                  "keyid:always,issuer:always")
        cert.add_extension(aki)
        cert.sign(rsa, OpenSSL::Digest::SHA1.new)

        return [ cert, rsa ]
      end
    end
  end
end
