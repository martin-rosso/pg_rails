# require 'rails_helper'
#
# describe PgEngine::SslVerifier do
#   describe 'check_ssl' do
#     subject do
#       described_class.new.check_ssl(url)
#     end
#
#     let(:url) { 'https://factura.bien.com.ar' }
#     let(:output_file) { File.read(PgEngine::SslVerifier::OUTPUT_PATH) }
#     let(:output_json) { JSON.parse(output_file) }
#
#     it 'checks the SSL certificate and saves the file' do
#       expect { subject }.not_to raise_error
#       expect(output_json.keys).to include 'https://bien.com.ar'
#     end
#   end
# end
