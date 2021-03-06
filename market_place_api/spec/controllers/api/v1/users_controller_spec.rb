require 'spec_helper'

describe Api::V1::UsersController do
  before(:each) { request.headers['Accept'] = "application/vnd.marketplace.v1" }

  describe "GET #show" do
    before(:each) do
      @user = FactoryGirl.create :user
      get :show, id: @user.id, format: :json
    end

    it "returns the information about a reporter on a hash" do
      expect(json_response[:email]).to eql @user.email
    end

    it "should respond_with 200 http status" do
      expect(response_status).to eql 200
    end
  end

  describe "POST #create" do
    context "when user is successfully created" do
      before(:each) do
        @user_attributes = FactoryGirl.attributes_for :user
        post :create, { user: @user_attributes }, format: :json
      end

      it "renders the json representation for the user record just created" do
        expect(json_response[:email]).to eql @user_attributes[:email]
      end

      it "should respond_with 201 http status" do
        expect(response_status).to eql 201
      end
    end

    context "when user is not created" do
      before(:each) do
        #not including the email
        @invalid_user_attributes = { password: "12345678",
                                     password_confirmation: "12345678" }
        post :create, { user: @invalid_user_attributes }, format: :json
      end

      it "renders an errors json" do
        expect(json_response[:errors]).to be_truthy
      end

      it "renders the json errors on why the user could not be created" do
        expect(json_response[:errors][:email]).to include "can't be blank"
      end

      it "should respond_with 422 http status" do
        expect(response_status).to eql 422
      end
    end
  end

  describe "PUT/PATCH #update" do
    context "when is successfully updated" do
      before(:each) do
        @user = FactoryGirl.create :user
        patch :update, { id: @user.id,
          user: { email: "newmail@example.com" } }, format: :json
      end

      it "renders the json representation for the updated user" do
        expect(json_response[:email]).to eql "newmail@example.com"
      end

      it "should respond_with 200 http status" do
        expect(response_status).to eql 200
      end
    end

    context "when is not created" do
      before(:each) do
        @user = FactoryGirl.create :user
        patch :update, { id: @user.id,
          user: { email: "bademail.com" } }, format: :json
      end

      it "renders an errors json" do
        expect(json_response[:errors]).to be_truthy
      end

      it "renders the json errors on why the user could not be created" do
        expect(json_response[:errors][:email]).to include "is invalid"
      end

      it "should respond_with 422 http status" do
        expect(response_status).to eql 422
      end
    end
  end

  describe "DELETE #destroy" do
    before(:each) do
      @user = FactoryGirl.create :user
      delete :destroy, { id: @user.id }, format: :json
    end

    it "should respond_with 200 http status" do
      expect(response_status).to eql 200
    end
  end
end