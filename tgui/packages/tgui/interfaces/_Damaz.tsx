import { Box, Button, Stack } from 'tgui-core/components';

import { useBackend } from '../backend';
import { Window } from '../layouts';

export const _Damaz = (props) => {
  const { act, data } = useBackend();
  const { king, admin, entries = [] } = data as any;

  return (
    <Window
      theme="dwarf"
      title="Damaz Kron"
      width={600}
      height={700}>
      <Window.Content scrollable>
        <Stack vertical>
          {entries.map((entry, index) => (
            <Stack.Item key={index}
              style={{ "borderBottom": "1px solid gray", "padding": "4px" }}>
              <Box bold
                style={{ "fontSize": "15px", "wordWrap": "break-word" }}>
                {entry.content}
              </Box>
              {admin && <Button onClick={() => act("remove_entry", { "entry": entries.indexOf(entry) })}>Delete</Button>}
              <Box italic textAlign="right" >
                - <b>{entry.author}</b> of <b>{entry.fortress}</b>
              </Box>
            </Stack.Item>
          ))}
        </Stack>
        <Button
          fluid
          textAlign="center"
          disabled={!king}
          onClick={() => act('add_entry')}>
          New Entry
        </Button>
      </Window.Content>
    </Window>
  );
};
