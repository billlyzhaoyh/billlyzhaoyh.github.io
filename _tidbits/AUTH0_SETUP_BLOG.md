# How to Configure Auth0 for MCP Servers with ChatGPT

Getting OAuth authentication working between Auth0 and ChatGPT's MCP (Model Context Protocol) connectors can be tricky. After hours of debugging `OAUTH_SCOPES_MISMATCH` errors, here's the complete guide to making it work.

## Official References

- [OpenAI: Developer mode, apps and MCP connectors in ChatGPT](https://help.openai.com/en/articles/12584461-developer-mode-apps-and-full-mcp-connectors-in-chatgpt-beta)
- [OpenAI Apps SDK: Authentication](https://developers.openai.com/apps-sdk/build/auth/)
- [Auth0: OpenID Connect Scopes](https://auth0.com/docs/get-started/apis/scopes/openid-connect-scopes)

## Prerequisites

- Auth0 account
- MCP server deployed with a public HTTPS URL

## Step 1: Create an API

1. Go to **Auth0 Dashboard** → **Applications** → **APIs** → **Create API**
2. Configure:
   - **Name**: Your MCP server name (e.g., `My MCP Server`)
   - **Identifier**: Your MCP server URL (e.g., `https://your-domain.com/mcp`)
   - **Signing Algorithm**: `RS256`
3. Click **Create**

### API Settings

After creating the API, go to the **Settings** tab and configure:

- **Allow Offline Access**: **Enable this** - Required for ChatGPT to obtain refresh tokens

## Step 2: Configure Default Audience

This is critical for Dynamic Client Registration (DCR) to work with ChatGPT.

1. Go to **Auth0 Dashboard** → **Settings** → **General**
2. Scroll to **API Authorization Settings**
3. Set **Default Audience** to your API identifier (e.g., `https://your-domain.com/mcp`)
4. Save changes

Without this, DCR clients (like ChatGPT) won't know which API to request tokens for, and you may receive encrypted JWE tokens instead of JWT.

## Step 3: Enable Social Connection for Third-Party Apps

ChatGPT uses Dynamic Client Registration (DCR) to create OAuth clients on the fly. These need to be authorized to use your identity providers.

1. Go to **Auth0 Dashboard** → **Authentication** → **Social**
2. Select your identity provider (e.g., **Google**)
3. Scroll down to **Advanced Settings**
4. Enable **"Allow for Third-Party Applications"**
5. Save changes

This allows DCR-created clients (like ChatGPT) to use social login.

## Step 4: Create Post-Login Action (Critical for ChatGPT)

This is the key fix for the `OAUTH_SCOPES_MISMATCH` error.

ChatGPT reads Auth0's `/.well-known/openid-configuration`, sees all the scopes in `scopes_supported`, and requests ALL of them. If Auth0 doesn't grant every single scope back, ChatGPT fails with a scope mismatch error.

1. Go to **Auth0 Dashboard** → **Actions** → **Flows** → **Login**
2. Click **"+"** to add a custom action
3. Name it: `Add Scopes for ChatGPT`
4. Add the following code:

```javascript
exports.onExecutePostLogin = async (event, api) => {
  // ChatGPT requests ALL scopes from Auth0's scopes_supported
  // We must grant them all to avoid OAUTH_SCOPES_MISMATCH error
  const scopes = [
    'openid', 'profile', 'offline_access', 'name', 'given_name',
    'family_name', 'nickname', 'email', 'email_verified', 'picture',
    'created_at', 'identities', 'phone', 'address'
  ];

  for (const scope of scopes) {
    api.accessToken.addScope(scope);
  }
};
```

5. Click **Deploy**
6. Drag the action into the Login flow and click **Apply**

### Why is this needed?

When ChatGPT initiates OAuth, it:
1. Fetches `/.well-known/openid-configuration` from Auth0
2. Reads the `scopes_supported` array (which includes ~13 OIDC scopes)
3. Requests ALL of them in the authorization request
4. Compares the granted scopes in the token response to what it requested
5. Fails if there's any mismatch

Without this Action, Auth0 doesn't include all these scopes in the token response, causing:

```json
{
  "error_code": "OAUTH_SCOPES_MISMATCH",
  "message": "Granted OAuth scopes do not match the requested scopes."
}
```

## Step 5: Configure Callback URLs (Optional for DCR)

If using a fixed application instead of DCR, add these callback URLs:

1. Go to **Applications** → Your Application → **Settings**
2. Add to **Allowed Callback URLs**:
   ```
   https://chatgpt.com/connector_platform_oauth_redirect
   https://platform.openai.com/apps-manage/oauth
   ```

For DCR (which ChatGPT uses by default), callback URLs are handled automatically during client registration.

## Step 6: Create M2M Application (Optional)

For testing or programmatic access without user login:

1. Go to **Applications** → **Create Application**
2. Select **Machine to Machine Applications**
3. Name: `MCP Server Test Client`
4. Authorize it for your MCP API
5. Save the **Client ID** and **Client Secret**

Test with:
```bash
curl -X POST "https://YOUR-TENANT.auth0.com/oauth/token" \
  -H "content-type: application/json" \
  -d '{
    "client_id": "YOUR_CLIENT_ID",
    "client_secret": "YOUR_CLIENT_SECRET",
    "audience": "https://your-domain.com/mcp",
    "grant_type": "client_credentials"
  }'
```

## Configuration Summary

| Setting | Location | Value |
|---------|----------|-------|
| API Identifier | APIs → Your API | Your MCP server URL |
| Allow Offline Access | APIs → Your API → Settings | Enabled |
| Default Audience | Settings → General → API Authorization | Your API identifier |
| Third-Party Apps | Authentication → Social → Provider | Enabled |
| Post-Login Action | Actions → Flows → Login | Add all OIDC scopes |

## Troubleshooting

### OAUTH_SCOPES_MISMATCH

**Symptom**: ChatGPT shows "Granted OAuth scopes do not match the requested scopes"

**Cause**: ChatGPT requests all scopes from `scopes_supported` but Auth0 doesn't grant them all.

**Fix**: Add the Post-Login Action (Step 4) to inject all required scopes.

### Token validation fails with JWE (encrypted token)

**Symptom**: Your MCP server receives an encrypted token (has 5 dot-separated parts instead of 3)

**Cause**: Default Audience is not set, so Auth0 doesn't know which API the token is for.

**Fix**: Set the Default Audience in Auth0 Settings (Step 2).

### DCR client can't use social login

**Symptom**: OAuth flow fails when trying to log in with Google/GitHub/etc.

**Cause**: Third-party applications aren't enabled for the social connection.

**Fix**: Enable "Allow for Third-Party Applications" on your social provider (Step 3).

### Refresh tokens not issued

**Symptom**: ChatGPT loses access after the access token expires

**Cause**: The API doesn't have offline access enabled.

**Fix**: Enable "Allow Offline Access" on your API (Step 1).

### "Not all requested permissions were granted"

**Symptom**: Auth0 consent screen works but ChatGPT still fails

**Cause**: Same as OAUTH_SCOPES_MISMATCH - the token response doesn't include all requested scopes.

**Fix**: Add the Post-Login Action (Step 4).

## Testing the Integration

1. In ChatGPT, go to **Settings** → **Developer Mode** → **Add MCP Server**
2. Enter your MCP server URL (e.g., `https://your-domain.com/mcp`)
3. ChatGPT will:
   - Discover OAuth metadata from `/.well-known/oauth-protected-resource/mcp`
   - Redirect to Auth0 for authentication
   - Exchange authorization code for tokens
   - Connect to your MCP server

If successful, you'll see your MCP tools available in ChatGPT.

## Debugging Tips

To see exactly what's happening during the OAuth flow:

1. **Auth0 Logs**: Check **Monitoring** → **Logs** for successful logins (`s` type) and see granted scopes in the details
2. **Browser DevTools**: Enable "Preserve log" in the Network tab to see requests across redirects
3. **Check the authorize request**: Look for the `scope` parameter to see what ChatGPT is requesting

## Conclusion

The key insight is that ChatGPT's MCP OAuth implementation requests ALL scopes from Auth0's `scopes_supported` metadata and expects an exact match in the response. The Post-Login Action workaround ensures Auth0 grants all these scopes, making the integration work.

This is arguably a quirk in how ChatGPT handles OAuth discovery, but until it's changed, this configuration will get your Auth0-protected MCP server working with ChatGPT.
