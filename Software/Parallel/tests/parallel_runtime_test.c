/*! @file parallel_runtime_test.c
 *  @brief Public-API smoke workload for the Parallel implementation.
 */

#include "picnic.h"

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MESSAGE_SIZE 32
#define SIGNATURE_REPETITIONS 4

static int runParameter(picnic_params_t parameter, const uint8_t* message)
{
    picnic_publickey_t publicKey;
    picnic_privatekey_t privateKey;
    uint8_t* signature = NULL;
    const size_t signatureCapacity = picnic_signature_size(parameter);
    int status = EXIT_FAILURE;

    if (picnic_keygen(parameter, &publicKey, &privateKey) != 0) {
        fputs("picnic_keygen failed\n", stderr);
        goto cleanup;
    }

    signature = malloc(signatureCapacity);
    if (signature == NULL) {
        fputs("signature allocation failed\n", stderr);
        goto cleanup;
    }

    for (size_t repetition = 0; repetition < SIGNATURE_REPETITIONS; repetition++) {
        size_t signatureLength = signatureCapacity;

        if (picnic_sign(&privateKey, message, MESSAGE_SIZE, signature, &signatureLength) != 0) {
            fputs("picnic_sign failed\n", stderr);
            goto cleanup;
        }
        if (picnic_verify(&publicKey, message, MESSAGE_SIZE, signature, signatureLength) != 0) {
            fputs("picnic_verify failed\n", stderr);
            goto cleanup;
        }
    }

    puts("parallel public-API workload passed");
    status = EXIT_SUCCESS;

cleanup:
    free(signature);
    return status;
}

int main(void)
{
    uint8_t message[MESSAGE_SIZE];

    memset(message, 0x5a, sizeof(message));
    for (picnic_params_t parameter = Picnic3_L1; parameter <= Picnic3_L5; parameter++) {
        if (runParameter(parameter, message) != EXIT_SUCCESS) {
            return EXIT_FAILURE;
        }
    }

    return EXIT_SUCCESS;
}
