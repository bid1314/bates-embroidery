require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  controller do
    def index
      render plain: 'test'
    end
  end

  before do
    routes.draw { get 'index' => 'anonymous#index' }
  end

  describe '#set_current_store' do
    context 'with retail subdomain' do
      before do
        allow(controller.request).to receive(:subdomain).and_return('retail')
      end

      it 'sets retail store as current store' do
        get :index
        expect(controller.instance_variable_get(:@current_store)).to be_present
        expect(controller.instance_variable_get(:@current_store).code).to eq('retail')
      end
    end

    context 'with b2b subdomain' do
      before do
        allow(controller.request).to receive(:subdomain).and_return('b2b')
      end

      it 'sets b2b store as current store' do
        get :index
        expect(controller.instance_variable_get(:@current_store)).to be_present
        expect(controller.instance_variable_get(:@current_store).code).to eq('b2b')
      end
    end

    context 'with no subdomain' do
      before do
        allow(controller.request).to receive(:subdomain).and_return('')
      end

      it 'defaults to retail store' do
        get :index
        expect(controller.instance_variable_get(:@current_store)).to be_present
        expect(controller.instance_variable_get(:@current_store).code).to eq('retail')
      end
    end
  end

  describe '#current_store_is_b2b?' do
    it 'returns true when current store is b2b' do
      allow(controller.request).to receive(:subdomain).and_return('b2b')
      get :index
      expect(controller.current_store_is_b2b?).to be true
    end

    it 'returns false when current store is retail' do
      allow(controller.request).to receive(:subdomain).and_return('retail')
      get :index
      expect(controller.current_store_is_b2b?).to be false
    end
  end

  describe '#current_store_is_retail?' do
    it 'returns true when current store is retail' do
      allow(controller.request).to receive(:subdomain).and_return('retail')
      get :index
      expect(controller.current_store_is_retail?).to be true
    end

    it 'returns false when current store is b2b' do
      allow(controller.request).to receive(:subdomain).and_return('b2b')
      get :index
      expect(controller.current_store_is_retail?).to be false
    end
  end

  describe '#hide_pricing_for_unapproved_b2b' do
    context 'on retail store' do
      before do
        allow(controller.request).to receive(:subdomain).and_return('retail')
      end

      it 'returns false' do
        get :index
        expect(controller.hide_pricing_for_unapproved_b2b).to be false
      end
    end

    context 'on b2b store' do
      before do
        allow(controller.request).to receive(:subdomain).and_return('b2b')
      end

      context 'with unauthenticated user' do
        it 'returns true' do
          get :index
          expect(controller.hide_pricing_for_unapproved_b2b).to be true
        end
      end

      context 'with authenticated b2b user' do
        let(:user) { create(:user) }
        let(:b2b_role) { create(:role, name: 'b2b_customer') }

        before do
          user.spree_roles << b2b_role
          allow(controller).to receive(:spree_current_user).and_return(user)
        end

        it 'returns false' do
          get :index
          expect(controller.hide_pricing_for_unapproved_b2b).to be false
        end
      end
    end
  end
end