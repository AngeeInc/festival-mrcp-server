#include <apr_pools.h>
#include <apt_dir_layout.h>
#include <apt.h>
#include <mrcp_application.h>
#include <mpf_termination.h>
#include <mrcp_message.h>
#include <mrcp_client_types.h>
#include <unimrcp_client.h>

#define MEM_ALLOC_SIZE      1024

// based on http://www.unimrcp.org/manuals/pdf/ClientIntegrationManual.pdf
// see http://www.unimrcp.org/dox/html/
// and http://www.unimrcp.org/manuals/pdf/ClientConfigurationManual.pdf
apt_bool_t msg_handler(const mrcp_app_message_t* message) {
    // TODO: msg handling
    return (apt_bool_t) 0;
}
int main(int argc, const char *argv[])
{   
    apr_status_t rv;
    apr_pool_t* mp;

    rv = apr_initialize();
    if (rv != APR_SUCCESS) {
        return -1;
    }

    apr_pool_create(&mp, NULL);

    apt_dir_layout_t* dl = apt_default_dir_layout_create("/unimrcp-1.1.0", mp);
    mrcp_client_t* mrcp_client = unimrcp_client_create(dl);
    mrcp_application_t* mrcp_app = mrcp_application_create(msg_handler, NULL, mp);
    mrcp_client_application_register(mrcp_client, mrcp_app, "TTS");
    mrcp_client_start(mrcp_client);
    mrcp_session_t* mrcp_session = mrcp_application_session_create(mrcp_app, "uni2", NULL);
    mpf_termination_t termination;
    mrcp_channel_t* mrcp_channel = mrcp_application_channel_create(mrcp_session, MRCP_SYNTHESIZER_RESOURCE, &termination, NULL, NULL);
    mrcp_application_channel_add(mrcp_session, mrcp_channel);
    
    // http://www.unimrcp.org/dox/html/mrcp__message_8h.html#adb503b7a264046b6e305930c50b02fd2
    //mrcp_message_t* msg = mrcp_message_create(mp);
    //mrcp_application_message_send(mrcp_session,mrcp_channel,mrcp_message);
    //on_message_receive(mrcp_app,mrcp_session_mrcp_channel,mrcp_message);
    
    mrcp_application_channel_remove(mrcp_session,mrcp_channel);
    mrcp_application_session_terminate(mrcp_session);
    apr_pool_destroy(mp);

    // TODO: SEGFAULT
    // apr_terminate();
    return 0;
}
